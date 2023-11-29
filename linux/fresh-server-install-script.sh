#!/bin/bash

# Declare variables
USERNAME="<YOUR USERNAME>"
PASSWORD="<YOUR PASSWORD>"
gecos="Last,First,123 Main St.,Seattle,WA,12345,123-456-7890"

# Add a sudo user and update their password
adduser $USERNAME --gecos "$gecos" --disabled-password

if [ $? -eq 0 ]; then
  echo "${USERNAME}:${PASSWORD}" | chpasswd
  usermod -aG sudo $USERNAME
else
  echo "Failed to add a user!"
  exit 1;
fi  

# Update SSH port to 69 (nice)
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sed -i 's/#Port 22/Port 69/g' /etc/ssh/sshd_config

# Apply any updates and upgrades
apt-get update && apt-get upgrade -y

# Prompt for reboot
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    shutdown -r now
fi