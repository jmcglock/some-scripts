#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update Ubuntu and Install Python
apt-get update && apt-get upgrade -y && apt-get install python3 -y

# Prompt for reboot
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi