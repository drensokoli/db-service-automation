#!/bin/bash

echo
echo -e "\033[32mRemoving Kafka and Zookeeper from your system\033[0m"
echo
# Stop Kafka and Zookeeper services
sudo systemctl stop kafka
sudo systemctl disable kafka
sudo systemctl stop zookeeper
sudo systemctl disable zookeeper

# Remove Kafka packages
sudo apt-get remove kafka

# Remove Kafka configuration files
sudo rm -rf /etc/kafka

# Remove Kafka data
sudo rm -rf /var/lib/kafka

# Remove Kafka logs
sudo rm -rf /var/log/kafka

# Remove Zookeeper packages
sudo apt-get remove zookeeper

# Remove Zookeeper configuration files
sudo rm -rf /etc/zookeeper

# Remove Zookeeper data
sudo rm -rf /var/lib/zookeeper

# Remove Zookeeper logs
sudo rm -rf /var/log/zookeeper

sudo rm /etc/systemd/system/kafka.service
sudo rm /etc/systemd/system/zookeeper.service
