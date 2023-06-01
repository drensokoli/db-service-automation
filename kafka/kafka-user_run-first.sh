#!/bin/bash

# Create kafka user
echo
echo -e "\033[32mCreating kafka user\033[0m"
echo
sudo adduser kafka
sudo usermod -aG sudo kafka

# Switch to kafka user
echo
echo -e "\033[32mSwitching to kafka user\033[0m"
echo
echo "Run the following command to complete kafka installation:"
echo
echo -e "\033[32m /codex/db-service-automation/kafka/kafka-setup.sh \033[0m"
echo
sudo su - kafka
