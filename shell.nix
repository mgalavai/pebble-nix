let
  pkgs = import <nixpkgs> {};
  pebbleEnv = (import (builtins.fetchTarball "https://github.com/Sorixelle/pebble.nix/archive/master.tar.gz")).pebbleEnv { };
in
pebbleEnv.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [
    pkgs.freetype
    pkgs.python27Packages.freetype-py  # Python 2.7 bindings for freetype
  ];
})