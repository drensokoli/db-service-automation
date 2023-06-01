#!/bin/bash

# Install Java
echo
echo -e "\033[32mInstalling Java"
echo
sudo apt update
sudo apt install openjdk-11-jdk

# Download and extract Kafka
echo
echo -e "\033[32mDownloading and extracting Kafka\033[0m"
echo
sudo mkdir ~/Downloads
sudo curl "https://downloads.apache.org/kafka/2.8.2/kafka_2.13-2.8.2.tgz" -o ~/Downloads/kafka.tgz
sudo mkdir ~/kafka
sudo tar -xvzf ~/Downloads/kafka.tgz --strip 1 -C ~/kafka

# Get host IP address
IP=$(curl ifconfig.me)

# Configure Kafka
echo
echo -e "\033[32mConfiguring Kafka\033[0m"
echo
sudo sed -i '/log.dirs/d' ~/kafka/config/server.properties
sudo echo "log.dirs=/home/kafka/logs" >> ~/kafka/config/server.properties
sudo echo "listeners=PLAINTEXT://:9092" >> ~/kafka/config/server.properties
sudo echo "advertised.listeners=PLAINTEXT://<SERVER_IP>:9092" >> ~/kafka/config/server.properties

# Settup systemd unit file
echo
echo -e "\033[32mSetting up systemd unit file\033[0m"
echo

## Kafka service
sudo cat > /etc/systemd/system/kafka.service  <<EOL
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/kafka.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOL

## Zookeeper service
sudo cat > /etc/systemd/system/zookeeper.service  <<EOL
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOL

# Change ownership and permissions of kafka directory and files
echo
echo -e "\033[32mChanging ownership and permissions of kafka directory and files\033[0m"
echo
sudo chown -R kafka /home/kafka
sudo chmod -R u+x /home/kafka

# Start Kafka and Zookeeper services
echo
echo -e "\033[32mStarting Kafka and Zookeeper services\033[0m"
echo
sudo systemctl daemon-reload
sudo systemctl start kafka
sudo systemctl enable kafka
sudo systemctl start zookeeper
sudo systemctl enable zookeeper

# Create Kafka topic
echo
echo -e "\033[32mTesting creation of Kafka topic\033[0m"
echo "In another terminal create a kafka consumer with the following command::"
echo "~/kafka/bin/kafka-console-consumer.sh --topic testTopic --bootstrap-server localhost:9092 --from-beginning"
echo "You should see the messages produced from the first terminal here."
echo

~/kafka/bin/kafka-topics.sh --create --topic testTopic --bootstrap-server localhost:9092
~/kafka/bin/kafka-console-producer.sh --topic testTopic --bootstrap-server localhost:9092
