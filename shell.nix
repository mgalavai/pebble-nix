let
  pkgs = import <nixpkgs> {};
  pebbleEnv = (import (builtins.fetchTarball "https://github.com/Sorixelle/pebble.nix/archive/master.tar.gz")).pebbleEnv { };
in
pkgs.mkShell {
  buildInputs = pebbleEnv.buildInputs ++ [
    pkgs.freetype
    pkgs.python27Packages.freetype-py
  ];
  shellHook = pebbleEnv.shellHook or "";
}