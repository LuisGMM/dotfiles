#!/bin/bash

set -e  # Exit script on error

# Define install directory
INSTALL_DIR="$HOME/.local/bin"
ZIG_PATH="$INSTALL_DIR/zig"
# Add Zig to PATH for both Bash and Zsh
PROFILE_FILES=("$HOME/.bashrc" "$HOME/.zshrc")

# Ensure install directory exists
mkdir -p "$INSTALL_DIR"

# Get the latest Zig version dynamically
echo "Fetching the latest Zig version..."
LATEST_ZIG_URL=$(curl -s https://ziglang.org/download/index.json | jq -r '.master."x86_64-linux".tarball')

if [[ -z "$LATEST_ZIG_URL" ]]; then
    echo "Error: Failed to fetch the latest Zig version."
    exit 1
fi

# Extract the filename from the URL
ZIG_FILENAME=$(basename "$LATEST_ZIG_URL")

# Download Zig
echo "Downloading $ZIG_FILENAME..."
wget -q --show-progress "https://ziglang.org$LATEST_ZIG_URL"

# Extract Zig
echo "Extracting $ZIG_FILENAME..."
tar -xf "$ZIG_FILENAME"

# Extract Zig folder name
ZIG_FOLDER=$(tar -tf "$ZIG_FILENAME" | head -1 | cut -d '/' -f1)

# Move Zig to the install directory
mv "$ZIG_FOLDER" "$ZIG_PATH"

# Cleanup downloaded files
rm "$ZIG_FILENAME"


for profile in "${PROFILE_FILES[@]}"; do
    if [[ -f "$profile" && ! $(grep -q "export PATH=\"$ZIG_PATH:\$PATH\"" "$profile") ]]; then
        echo "export PATH=\"$ZIG_PATH:\$PATH\"" >> "$profile"
    fi
done

# Apply the updated PATH in the current shell session
export PATH="$ZIG_PATH:$PATH"

# Verify Zig installation
echo "Zig installation completed!"
zig version

