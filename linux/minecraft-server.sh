#!/bin/bash

## Step 1: Install Java Runtime Environment (JRE)

# Update the package index and installed packages
sudo apt update && sudo apt upgrade -y

# Install the required packages
sudo apt install software-properties-common screen -y

# Add the repository for JDK-17
sudo add-apt-repository ppa:linuxuprising/java -y
sudo apt update

# Install Oracle Java 17 and make it default
sudo apt install oracle-java17-installer --install-recommends -y

## Step 2: Download Minecraft Server Jar

# Create the Minecraft server directory
sudo mkdir /opt/minecraft

# Download the Minecraft server jar file
wget https://piston-data.mojang.com/v1/objects/5b868151bd02b41319f54c8d4061b8cae84e665c/server.jar

# Move the jar file
sudo mv server.jar /opt/minecraft
cd /opt/minecraft

# Run the server once to generate eula.txt file, then kill it
sudo java -jar server.jar --nogui &
sleep 10
pkill -f server.jar

# Accept the EULA
echo 'eula=true' | sudo tee eula.txt

## Step 3: Configure Minecraft environment script

# Create the start.sh script
echo '#!/bin/sh
cd "$(dirname "$0")
exec java -Xmx1024M -Xms1024M -jar server.jar --nogui' | sudo tee start.sh

# Make the file executable
sudo chmod a+x start.sh

# Create a user and group for Minecraft
sudo adduser --system --home /opt/minecraft minecraft
sudo groupadd minecraft
sudo adduser minecraft minecraft 

# Assign ownership of the Minecraft directory to the Minecraft user
sudo chown -R minecraft:minecraft /opt/minecraft

# Create the systemd service file
echo '[Unit]
Description=start and stop the minecraft-server

[Service]
WorkingDirectory=/opt/minecraft
User=minecraft
Group=minecraft
Restart=on-failure
RestartSec=20 5
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar --nogui

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/minecraft.service

# Reload the system daemon, enable, and start the service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

## Step 4: Configure Firewall Service

# Enable and configure the firewall
sudo ufw enable
sudo ufw allow 25565/tcp

# Enable the whitelist mode
sudo sh -c 'echo "white-list=true" >> /opt/minecraft/server.properties'

# Restart the server
sudo systemctl restart minecraft