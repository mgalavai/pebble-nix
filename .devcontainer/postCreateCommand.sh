#!/bin/bash
set -e

echo "📦 Setting up Pebble SDK in Codespaces..."

# Ensure Nix is available
if ! command -v nix >/dev/null; then
  echo "🚨 Nix is not installed. Exiting."
  exit 1
fi

# Initialize Nix
. /home/codespace/.nix-profile/etc/profile.d/nix.sh

# Clone pebble.nix if not already present
if [ ! -d "pebble.nix" ]; then
  git clone https://github.com/pebble-dev/pebble.nix.git
fi

# Enter the development shell
cd pebble.nix
nix develop

# Install X11 server for the emulator
sudo apt update && sudo apt install -y x11vnc xvfb

# Start a virtual framebuffer (to run Pebble emulator headlessly)
Xvfb :99 -screen 0 1440x900x16 &

# Export DISPLAY so programs know where to render graphics
export DISPLAY=:99

# Start a VNC server for the emulator
x11vnc -display :99 -forever -nopw -listen 0.0.0.0 -xkb &

echo "✅ Pebble SDK is ready to use!"
