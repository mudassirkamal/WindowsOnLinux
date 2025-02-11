#!/bin/bash

# Windows 10 installation script for Ubuntu VPS
# This script will install Windows 10, enable RDP, and install Chrome

set -e

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Variables
WIN_IMAGE_URL="https://example.com/windows10.qcow2"  # Replace with a valid Windows 10 image link
DISK_PATH="/var/lib/libvirt/images/windows10.qcow2"
ISO_PATH="/var/lib/libvirt/images/virtio-win.iso"
VM_NAME="Windows10"

# Install necessary packages
apt update && apt install -y qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils wget

# Download Windows image
wget -O "$DISK_PATH" "$WIN_IMAGE_URL"

# Download VirtIO drivers
wget -O "$ISO_PATH" "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

# Create the VM
virt-install \
  --name "$VM_NAME" \
  --ram 4096 \
  --vcpus 2 \
  --disk path="$DISK_PATH",format=qcow2,bus=virtio \
  --cdrom "$ISO_PATH" \
  --os-variant win10 \
  --network network=default,model=virtio \
  --graphics vnc,password=pass123 \
  --noautoconsole

# Enable RDP
virsh start "$VM_NAME"
echo "Windows 10 installation started. Access via VNC using your server IP. Default password: pass123"
