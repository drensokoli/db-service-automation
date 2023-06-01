#!/bin/bash

# Import the public key used by the package management system
echo
echo -e "\033[32mImporting the public key used by the package management system\033[0m"
echo
sudo apt-get install gnupg

curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor

# Get the current version of Ubuntu
version=$(lsb_release -r | awk '{print $2}')

echo
echo "Select an Ubuntu version:"
echo "1. Ubuntu 16.04 (Xenial)"
echo "2. Ubuntu 18.04 (Bionic)"
echo "3. Ubuntu 20.04 (Focal)"
echo "4. Ubuntu 22.04 (Jammy)"
echo
echo "Current version: Ubuntu $version "

# Get the current Ubuntu version
version=$(lsb_release -rs)

# Read users's choice and validate it
read choice

while [[ $choice != 1 && $choice != 2 && $choice != 3 && $choice != 4 ]]; do
  echo "Please enter a valid choice:"
  echo
  echo "Select an Ubuntu version:"
  echo "1. Ubuntu 16.04 (Xenial)"
  echo "2. Ubuntu 18.04 (Bionic)"
  echo "3. Ubuntu 20.04 (Focal)"
  echo "4. Ubuntu 22.04 (Jammy)"
  echo
  echo "Current version: Ubuntu $version "
  read choice
done

# Output the name of the selected Ubuntu version and add the MongoDB repository
case $choice in
  1) echo "You selected Ubuntu 16.04 (Xenial)"
     echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list;;
  2) echo "You selected Ubuntu 18.04 (Bionic)"
     echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list;;
  3) echo "You selected Ubuntu 20.04 (Focal)"
     echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list;;
  4) echo "You selected Ubuntu 22.04 (Jammy)"
     echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list;;
  *) echo "Invalid choice";;
esac

# Reload local package database
echo
echo -e "\033[32mReload local package database\033[0m"
echo
sudo apt-get update

# Install the MongoDB packages
echo
echo -e "\033[32mInstall the MongoDB packages\033[0m"
echo
sudo apt-get install -y mongodb-org=6.0.4 mongodb-org-database=6.0.4 mongodb-org-server=6.0.4 mongodb-org-mongos=6.0.4 mongodb-org-tools=6.0.4

# Prevent unintended upgrades
echo
echo -e "\033[32mPrevent unintended upgrades\033[0m"
echo
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

echo "MongoDB version 6.0.4 has been installed"
echo "Connect to mongo shell using the command: mongosh"

# Start MongoDB
echo
echo -e "\033[32mStarting MongoDB\033[0m"
echo
sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

