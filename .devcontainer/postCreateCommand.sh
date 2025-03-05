#!/bin/bash
set -euo pipefail
set -x

echo "============================================"
echo "Starting postCreateCommand.sh for Pebble SDK Setup"
echo "============================================"

# Step 1: Check and install Nix if missing
echo "Step 1: Checking for Nix installation"
if ! command -v nix >/dev/null 2>&1; then
  echo "Nix not found. Installing Nix..."
  curl -L https://nixos.org/nix/install | sh
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    echo "Sourcing Nix profile..."
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  else
    echo "ERROR: Nix profile not found after installation!"
    exit 1
  fi
  echo "Persisting Nix environment for future sessions..."
  echo "source \$HOME/.nix-profile/etc/profile.d/nix.sh" >> "$HOME/.bashrc"
  echo "source \$HOME/.nix-profile/etc/profile.d/nix.sh" >> "$HOME/.zshrc"
else
  echo "Nix is already installed. Sourcing Nix profile..."
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Step 2: Configure experimental features for Nix
echo "Step 2: Configuring Nix experimental features (nix-command, flakes)"
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
else
  echo "Experimental features already set."
fi

# Step 3: Clone pebble.nix repository if it does not exist
echo "Step 3: Cloning pebble.nix repository"
if [ ! -d "$HOME/pebble.nix" ]; then
  git clone https://github.com/pebble-dev/pebble.nix.git "$HOME/pebble.nix" || { echo "ERROR: Failed to clone pebble.nix repository"; exit 1; }
else
  echo "pebble.nix repository already exists at $HOME/pebble.nix"
fi

# Step 4: Install X11 dependencies required for the Pebble emulator
echo "Step 4: Installing X11 dependencies (Xvfb and x11vnc)"
sudo apt-get update
sudo apt-get install -y xvfb x11vnc

# Step 5: Start Xvfb with a resolution matching Pebble device screens
echo "Step 5: Starting virtual display (Xvfb) on :99 with resolution 144x168x16"
Xvfb :99 -screen 0 144x168x16 &
export DISPLAY=:99

# Step 6: Start x11vnc server for the emulator display
echo "Step 6: Starting x11vnc server on display :99"
x11vnc -display :99 -forever -nopw -listen 0.0.0.0 -xkb &

echo "============================================"
echo "Pebble SDK and Emulator Environment Setup Complete!"
echo "To enter the SDK environment, run: cd \$HOME/pebble.nix && nix develop"
echo "============================================"
