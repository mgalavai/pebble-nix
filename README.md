# Pebble Hello World App

A simple Hello World application for Pebble smartwatches, built with Nix.

## Building

To build this project, you need to have Nix installed with flakes enabled.

```bash
# Build the project
nix build

# The result will be available in the `result` directory
ls -l result/bin/hello-world.pbw
```

## Development

To enter a development environment with all necessary tools:

```bash
nix develop
```

## Project Structure

- `src/main.c` - Main application code for the Pebble app
- `package.json` - Pebble project configuration
- `flake.nix` - Nix build configuration

## GitHub Actions

This project uses GitHub Actions to automatically build the app on each commit. 