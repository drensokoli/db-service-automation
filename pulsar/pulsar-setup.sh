#!/bin/bash

# Install Java
echo
echo -e "\033[32mInstalling Java 17.x\033[0m"
echo
sudo apt-get update
sudo apt install openjdk-17-jdk openjdk-17-jre

# Download the official Apache Pulsar distribution
echo
echo -e "\033[32mDownloading Apache Pulsar distribution\033[0m"
echo
sudo mkdir ~/Downloads
sudo wget -P ~/Downloads https://archive.apache.org/dist/pulsar/pulsar-2.11.1/apache-pulsar-2.11.1-bin.tar.gz
sudo tar xvfz ~/Downloads/apache-pulsar-2.11.1-bin.tar.gz -C ~/Downloads

# Configure Apache Pulsar
echo
echo -e "\033[32mConfiguring Apache Pulsar\033[0m"
echo
sudo sed -i '/-XX:+UseZGC/d' ~/Downloads/apache-pulsar-2.11.1/conf/pulsar_env.sh
echo "PULSAR_GC=${PULSAR_GC:-"-XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch"}" >> ~/Downloads/apache-pulsar-2.11.1/conf/pulsar_env.sh

# Start Apache Pulsar
echo
echo -e "\033[32mTo start Apache Pulsar run:\033[0m"
echo
echo "sudo ~/Downloads/apache-pulsar-2.11.1/bin/pulsar standalone"
echo
