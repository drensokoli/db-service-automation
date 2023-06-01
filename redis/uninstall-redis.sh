#!/bin/bash

echo -e "\033[32mUninstalling redis-server.service\033[0m"

sudo systemctl stop redis-server.service

sudo apt-get purge --auto-remove redis-server

sudo rm -rf /etc/redis/
sudo rm -rf /var/lib/redis/
sudo rm -rf /var/log/redis/
