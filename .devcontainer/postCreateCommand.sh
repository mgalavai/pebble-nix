#!/bin/bash
set -e  # Exit immediately on error.
set -x  # Enable command tracing for detailed logs.

echo "============================"
echo "Starting postCreateCommand.sh"
echo "============================"

echo "📦 Setting up Pebble SDK in Codespaces..."

# Install Nix manually if not already installed
if ! command -v nix >/dev/null; then
  echo "🚀 Installing Nix..."
  curl -L https://nixos.org/nix/install | sh

  # Source the profile immediately to load nix commands
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    echo "Sourcing Nix profile..."
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  else
    echo "ERROR: Nix profile script not found!"
    exit 1
  fi

  # Persist the Nix environment for future sessions
  echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc
  echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.zshrc
else
  echo "Nix is already installed."
fi

# Ensure the directory for Nix configuration exists
echo "Ensuring ~/.config/nix directory exists..."
mkdir -p ~/.config/nix

# Enable experimental features: nix-command and flakes
echo "Configuring Nix experimental features..."
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Clone pebble.nix repository if it does not already exist
echo "Checking for pebble.nix repository..."
if [ ! -d "pebble.nix" ]; then
  echo "Cloning pebble.nix repository..."
  git clone https://github.com/pebble-dev/pebble.nix.git || { echo "ERROR: Failed to clone pebble.nix repository"; exit 1; }
else
  echo "pebble.nix repository already exists."
fi

# Navigate into the pebble.nix directory
echo "Entering the pebble.nix directory..."
cd pebble.nix

# Launch Nix development shell; running in background to avoid blocking further commands.
echo "Starting Nix development shell (nix develop)..."
nix develop &

# Install X11 dependencies for the emulator
echo "Installing X11 dependencies..."
sudo apt update && sudo apt install -y x11vnc xvfb

# Start a virtual display with Xvfb
echo "Starting virtual display (Xvfb)..."
Xvfb :99 -screen 0 1440x900x16 &
export DISPLAY=:99

# Start the VNC server for the emulator
echo "Starting VNC server (x11vnc)..."
x11vnc -display :99 -forever -nopw -listen 0.0.0.0 -xkb &

echo "✅ Pebble SDK is ready to use!"
echo "============================"
echo "Finished postCreateCommand.sh execution."
echo "============================"
