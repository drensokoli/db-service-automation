#!/bin/bash

# Update your package list

echo
echo -e "\033[32mUpdating your package list\033[0m"
echo
sudo apt-get update

# Add the official Redis APT repository
echo
echo -e "\033[32mAdding the official Redis APT repository\033[0m"
echo
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

# Update your package list again
sudo apt-get update

# Install Redis
echo 
echo -e "\033[32mInstalling Redis\033[0m"
echo
sudo apt install redis -y

# Create a new Redis service file
echo
echo -e "\033[32mCreating a new Redis service file\033[0m"
echo
cat > /etc/systemd/system/redis.service << EOL
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Create a Redis user and group, and set the necessary permissions
echo
echo -e "\033[32mCreating a Redis user and group, and setting the necessary permissions\033[0m"
echo
sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

# Start and enable the Redis service
echo
echo -e "\033[32mStarting and enabling the Redis service\033[0m"
echo
sudo systemctl daemon-reload
sudo systemctl start redis
sudo systemctl enable redis

# Configure Redis for production
echo
echo -e "\033[32mConfiguring Redis for production\033[0m"
echo
sed -i '/supervised/d' /etc/redis/redis.conf
sed -i '/bind /d' /etc/redis/redis.conf

echo "supervised systemd" >> /etc/redis/redis.conf
echo "bind 0.0.0.0 ::1" >> /etc/redis/redis.conf

# Create password for new redis user
PASSWORD=$(openssl rand -base64 12 | tr -d '\n' | cut -c 1-8)

# Add a user with the desired password and permissions
echo
echo -e "\033[32mAdding a user with the desired password and permissions\033[0m"
echo
cat > /etc/redis/users.acl << EOL
user default on >${PASSWORD} ~* +@all

EOL

## Set the aclfile directive to point to the newly created ACL file
echo
echo -e "\033[32mSetting the aclfile directive to point to the newly created ACL file\033[0m"
echo
sed -i '/aclfile /d' /etc/redis/redis.conf
echo "aclfile /etc/redis/users.acl" >> /etc/redis/redis.conf

# Restart the Redis server
echo
echo -e "\033[32mRestarting the Redis server\033[0m"
echo
sudo systemctl restart redis-server

# Allow port 6379 on firewall
echo
echo -e "\033[32mAllowing port 6379 on firewall...\033[0m"
echo
sudo ufw allow 6379/tcp

# Get host IP address
IP=$(curl ifconfig.me)

# Check redis-server.service status
echo
echo -e "\033[32mCheck the status of redis-server.service by running:\033[0m"
echo
echo "systemctl status redis-server.service"

# Display the connection string
echo
echo -e "\033[32mRedis Connection details:\033[0m"
echo
echo "Host: ${IP}"
echo "Port: 6379"
echo "Password: ${PASSWORD}"
echo
echo -e "\033[32mConnection string:\033[0m"
echo
echo "redis://default:${PASSWORD}@${IP}:6379"
echo
