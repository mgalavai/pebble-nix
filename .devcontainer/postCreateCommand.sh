#!/bin/bash
set -e

echo "📦 Setting up Pebble SDK in Codespaces..."

# Install Nix manually
if ! command -v nix >/dev/null; then
  echo "🚀 Installing Nix..."
  curl -L https://nixos.org/nix/install | sh
  source ~/.nix-profile/etc/profile.d/nix.sh
  echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc
  echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.zshrc
fi

# Clone pebble.nix if not present
if [ ! -d "pebble.nix" ]; then
  git clone https://github.com/pebble-dev/pebble.nix.git
fi

# Enter Pebble SDK environment
cd pebble.nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
source ~/.nix-profile/etc/profile.d/nix.sh
nix develop

# Install X11 for emulator
sudo apt update && sudo apt install -y x11vnc xvfb

# Start virtual display
Xvfb :99 -screen 0 1440x900x16 &
export DISPLAY=:99

# Start VNC for emulator
x11vnc -display :99 -forever -nopw -listen 0.0.0.0 -xkb &

echo "✅ Pebble SDK is ready to use!"
