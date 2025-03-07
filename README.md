# Pebble Cloud Development Environment

A full-featured Pebble smartwatch development environment in the cloud. This project makes it possible to develop Pebble apps without needing to install the SDK locally.

## Latest Update
- Fixed build issues in GitHub Actions:
  - Replaced nodejs-14_x with generic nodejs package
  - Updated pkgconfig to pkg-config for compatibility with newer Nixpkgs
  - Fixed virtualenv incompatibility by pinning to version 16.7.9 (last version supporting Python 2.7)
- Added additional debug information to the build process
- Enhanced error handling in the GitHub Actions workflow

## Features

- **Cloud-Based Compilation** - Build Pebble apps in GitHub Actions
- **Real Pebble SDK** - Uses the actual Pebble SDK 4.5 for compilation
- **Reproducible Builds** - Nix ensures consistent builds across environments
- **JavaScript Support** - Includes PebbleKit JS for communication with phone apps

## Building

This project uses Nix flakes to manage dependencies and ensure reproducible builds.

```bash
# Build the project in the cloud (via GitHub Actions)
# Simply commit your changes and push to GitHub

# To build locally if you have Nix installed:
nix build
```

## Project Structure

- `src/main.c` - Main C code for the Pebble watchapp
- `src/js/app.js` - JavaScript component for phone communication
- `resources/` - Images and other resources for the watchapp
- `appinfo.json` - Pebble app configuration
- `wscript` - Build configuration for the Pebble SDK
- `flake.nix` - Nix build configuration with Pebble SDK integration

## Development

There are two ways to develop with this project:

### Cloud Development (Recommended)
1. Fork this repository
2. Make changes to the code
3. Commit and push to GitHub
4. GitHub Actions will build your app
5. Download the built .pbw file from the workflow artifacts

### Local Development
If you want to develop locally:

```bash
# Enter a development shell with the Pebble SDK
nix develop

# In the shell, you can use standard Pebble commands
pebble build
```

## Future Plans

- Web-based IDE integration
- Emulator streaming to browser
- Direct deployment to Pebble watches

## License

MIT 