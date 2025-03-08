{
  description = "Pebble App Build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pebble-nix.url = "github:pebble-dev/pebble.nix";
  };

  outputs = { self, nixpkgs, pebble-nix }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      pebbleEnv = pebble-nix.pebbleEnv { inherit pkgs; };
    in
    {
      pebble-app = pkgs.stdenv.mkDerivation {
        name = "pebble-app";
        src = ./.;
        buildInputs = [ pebbleEnv ];
        buildPhase = ''
          pebble build
        '';
        installPhase = ''
          mkdir -p $out
          cp build/*.pbw $out/
        '';
      };
    };
}