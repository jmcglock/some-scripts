#!/bin/bash

# Update the package list and install all updates
sudo apt update && sudo apt upgrade -y

# Install snapd and the Snap Store
sudo apt update && sudo apt install -y snapd
if [ $? -eq 0 ]; then
    sudo snap install snap-store
else
    echo "Failed to install snapd. Exiting..."
    exit 1
fi

# Install snaps
snaps=(
    "code --classic"
    "discord"
    "signal-desktop"
    "termius-app"
)

for snap in "${snaps[@]}"; do
  sudo snap install $snap
done

# Adding a function for adding repository safely
add_repo_and_key() {
    local repo_uri="$1"
    local key_uri="$2"
    local list_file="$3"
    local key_file="$4"

    echo "deb $repo_uri /" | sudo tee "$list_file"
    curl -fsSL "$key_uri" | gpg --dearmor | sudo tee "$key_file" > /dev/null
    sudo apt update
}

# Add the repository for onedriver and install packages
add_repo_and_key "http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/" \
"https://download.opensuse.org/repositories/home:jstaf/xUbuntu_22.04/Release.key" \
"/etc/apt/sources.list.d/home:jstaf.list" \
"/etc/apt/trusted.gpg.d/home_jstaf.gpg"

# Install additional applications
packages=(
    "onedriver"
    "gnome-tweaks"
    "space"
    "spotify-client"
    "starship"
    "brave-browser"
)

for package in "${packages[@]}"; do
  sudo apt install -y $package
done

# Prompt for reboot
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo  # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
else
    echo "Reboot skipped. Don't forget to reboot later!"
fi