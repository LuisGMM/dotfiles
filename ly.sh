#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo snap install zig --classic --beta
sudo apt update && sudo apt install -y \
    build-essential \
    libpam0g-dev \
    libxcb-xkb-dev \

# Clone the Ly repository
echo "Cloning Ly repository..."
git clone https://github.com/fairyglade/ly.git ~/ly

# Navigate to the Ly directory
cd ~/ly

# Build and install Ly using Zig
echo "Building and installing Ly..."
zig build
sudo zig build installsystemd

# Disable other display managers (if applicable)
echo "Disabling other display managers (if needed)..."
sudo systemctl disable gdm sddm lightdm || true

# # Enable and start the Ly service
echo "Enabling and starting the Ly service..."
sudo systemctl enable ly.service
sudo systemctl start ly.service


echo "Ly installation complete! Please reboot your system to apply the changes."

