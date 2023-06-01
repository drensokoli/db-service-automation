#!/bin/bash
# Read the user's choice

echo
echo "Select an Ubuntu version:"
echo "1. Ubuntu 16.04 (Xenial)"
echo "2. Ubuntu 18.04 (Bionic)"
echo "3. Ubuntu 20.04 (Focal)"
echo "4. Ubuntu 22.04 (Jammy)"
echo
echo "Current version: Ubuntu $version "
read choice

# Get the current Ubuntu version
version=$(lsb_release -rs)

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

