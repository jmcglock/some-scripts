#!/bin/bash

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Update the package manager and upgrade installed packages
apt-get update && apt-get upgrade -y || { echo "Updating and upgrading failed"; exit 1; }

# Install the required dependencies
apt-get install git dnsutils bc -y || { echo "Installing dependencies failed"; exit 1; }

# Determine the Pi-hole directory and remove if it already exists
PI_HOLE_DIR="/root/Pi-hole"
if [ -d "$PI_HOLE_DIR" ]; then
    echo "Pi-hole directory exists. Removing and refreshing..."
    rm -rf "$PI_HOLE_DIR" || { echo "Failed to remove existing Pi-hole directory"; exit 1; }
fi

# Clone the Pi-hole installation script from GitHub
git clone --depth 1 https://github.com/pi-hole/pi-hole.git "$PI_HOLE_DIR" || { echo "Cloning Pi-hole repository failed"; exit 1; }

# Navigate to the Pi-hole automated install directory
PI_HOLE_INSTALL_DIR="${PI_HOLE_DIR}/automated install"
if [ -d "$PI_HOLE_INSTALL_DIR" ]; then
    cd "$PI_HOLE_INSTALL_DIR" || { echo "Failed to change to Pi-hole install directory"; exit 1; }
else
    echo "Pi-hole install directory does not exist"
    exit 1
fi

# Run the Pi-hole installation script
bash basic-install.sh || { echo "Running Pi-hole install script failed"; exit 1; }