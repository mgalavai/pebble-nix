{
  description = "Pebble Hello World App";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "pebble-hello-world";
          version = "0.1.0";
          
          src = ./.;

          # This is a placeholder build script - in a real project you'd use the 
          # actual Pebble SDK build commands here
          buildPhase = ''
            echo "Building a simple Pebble Hello World app..."
            mkdir -p $out/bin
            echo "This is a placeholder for the Pebble app binary" > $out/bin/hello-world.pbw
          '';

          installPhase = ''
            echo "Installing Pebble app..."
            mkdir -p $out
          '';

          meta = {
            description = "A simple Hello World app for Pebble";
            license = pkgs.lib.licenses.mit;
          };
        };

        # Add a default app that can be run with `nix run`
        apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

        # Development shell with required tools
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs # For Pebble development
          ];
        };
      });
} 