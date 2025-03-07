# Pebble Hello World App

A simple Hello World app for Pebble smartwatches, built using Nix and pebble.nix.

## Building

### Local Development

To build this app locally, you need Nix installed on your system:

1. Clone this repository
2. Run `nix-shell` to enter the development environment
3. Run `pebble build` to build the app

### GitHub Actions

This repository is configured with GitHub Actions to automatically build the app on every push. The workflow:

1. Sets up a Nix environment
2. Uses the Pebble binary cache via Cachix
3. Builds the app using pebble.nix

## Project Structure

- `appinfo.json` - App metadata and configuration
- `src/main.c` - Main application code
- `wscript` - Build configuration for the Pebble SDK
- `shell.nix` - Nix environment configuration using pebble.nix

## Credits

This project uses [pebble.nix](https://github.com/Sorixelle/pebble.nix) by Sorixelle to provide the Pebble SDK and build environment. 