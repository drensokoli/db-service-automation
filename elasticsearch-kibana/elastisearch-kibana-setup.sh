#!/bin/bash

# Install Java
echo
echo -e "\033[32mInstalling Java\033[0m"
echo
sudo apt update
sudo apt install openjdk-11-jdk

# Set the JAVA_HOME environment variable
echo
echo -e "\033[32mSetting the JAVA_HOME environment variable\033[0m"
echo
echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed 's:/bin/java::')" >> /etc/environment source /etc/environment

# Download the Elasticsearch GPG Key and register it in your system
echo
echo -e "\033[32mDownloading the Elasticsearch GPG Key and register it in your system\033[0m"
echo
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

# Update the package index and install Elasticsearch
echo
echo -e "\033[32mUpdate the package index and install Elasticsearch\033[0m"
echo
sudo apt update
sudo apt install elasticsearch

# Configure Elasticsearch
echo
echo -e "\033[32mConfiguring Elasticsearch\033[0m"
echo
sudo sed -i 's/cluster.name:/d' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/network.host:/d' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/xpack.security.enabled/,/# Additional nodes can still join the cluster later/d' /etc/elasticsearch/elasticsearch.yml 

cat > /etc/elasticsearch/elasticsearch.yml << EOL
xpack.security.enabled: false

xpack.security.enrollment.enabled: false

# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: false
  keystore.path: certs/http.p12

# Enable encryption and mutual authentication between cluster nodes
xpack.security.transport.ssl:
  enabled: false
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
# Create a new cluster with the current node only
# Additional nodes can still join the cluster later

cluster.name: my_cluster
network.host: 0.0.0.0
EOL

# Start the Elasticsearch service and enable it to start on boot
echo
echo -e "\033[32mStarting the Elasticsearch service and enable it to start on boot\033[0m"
echo
sudo systemctl daemon-reload
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Installing Kibana
echo
echo -e "\033[32mInstalling Kibana\033[0m"
echo
sudo apt update
sudo apt install kibana

# Get the public IP address of your Elasticsearch node
IP=$(curl ifconfig.me)

# Configure Kibana
echo
echo -e "\033[32mConfiguring Kibana\033[0m"
echo

sudo sed -i 's/server.host:/d' /etc/kibana/kibana.yml
sudo sed -i 's/elasticsearch.hosts:/d' /etc/kibana/kibana.yml

echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
echo "elasticsearch.hosts: ['http://${IP}:9200']" >> /etc/kibana/kibana.yml 

# Start and enable the Kibana service
echo
echo -e "\033[32mStarting and enabling the Kibana service\033[0m"
echo
sudo systemctl daemon-reload
sudo systemctl start kibana
sudo systemctl enable kibana

echo
echo -e "\033[32mTHE ELASTICSEARCH AND KIBANA SERVICES HAVE BEEN CONFIGURED TO NOT USE AUTHENTICATION\033[0m"
echo

