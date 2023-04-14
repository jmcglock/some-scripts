#!/bin/bash

# Add a sudo user and update their password
USERNAME="<YOUR USERNAME>"
PASSWORD="<YOUR PASSWORD>"
adduser $USERNAME --gecos "Last,First,123 Main St.,Seattle,WA,12345,123-456-7890" --disabled-password
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo $USERNAME

# Update SSH port to 69 (nice)
sed -i 's/#Port 22/Port 69/g' /etc/ssh/sshd_config

# Apply any updates and upgrades
apt-get update && apt-get upgrade -y

# Reboot the server
shutdown -r now