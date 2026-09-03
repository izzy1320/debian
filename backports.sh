#!/usr/bin/bash

# Exit on error
set -e

# Change sources to new debian format
sudo apt modernize-sources --assume-yes

# Create a backup of the modern debian.sources format file
sudo cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak

# Automatically append contrib and non-free components if they aren't already added
sudo sed -i '/^Components:/ s/$/ contrib non-free/' /etc/apt/sources.list.d/debian.sources

# Generate modern DEB822 repository file for trixie-backports
sudo tee /etc/apt/sources.list.d/debian-backports.sources << 'EOF'
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: trixie-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
Enabled: yes
EOF


# Create the apt pinning configuration file for trixie-backports
sudo tee /etc/apt/preferences.d/trixie-backports << 'EOF'
Package: *
Pin: release n=trixie-backports
Pin-Priority: 900
EOF

# Refresh & Apply
sudo apt update && sudo apt full-upgrade -y

# Done
echo "Sources updated and backports installed.  Rebooting system now..."
sleep 3
sudo reboot
