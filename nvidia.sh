#!/usr/bin/bash

# Exit if error
set -e 

# Download the keychain & repository
wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb

# Install the keychain
sudo dpkg -i ./cuda-keyring_1.1-1_all.deb

# Update
sudo apt update

# Pin the 610 branch
sudo apt install -y nvidia-driver-pinning-615

# Install Driver
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -V -y nvidia-open

# Back up the current GRUB configuration just in case
sudo cp /etc/default/grub /etc/default/grub.bak

# Inject parameters inside the existing quotes of GRUB_CMDLINE_LINUX_DEFAULT
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ intel_pstate=active nvidia-drm.modeset=1"/' /etc/default/grub

# Update GRUB configurations to apply changes
sudo update-grub

# Finish
echo "Nvidia drivers installed and grub updated.  Rebooting system now..."
sleep 3
sudo reboot
