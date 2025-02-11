#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Run as root!"
  exit 1
fi
IMAGE_URL="https://archive.org/download/win-10.-pro_20240204/WIN10.PRO.gz"
echo "Downloading Windows image..."
wget -O win2019.gz $IMAGE_URL || curl -L $IMAGE_URL -o win2019.gz
echo "Installing Windows..."
gunzip -c win2019.gz | dd of=/dev/vda bs=4M status=progress
echo "Installation complete. Rebooting..."
reboot
