{ pkgs, toolchain }:
let
  rustPkgs = import ./rust/pkgs.nix { inherit toolchain pkgs; };

  mdbookPkgs = import ./mdbook/pkgs.nix { inherit pkgs; };

  nixPkgs = import ./nix/pkgs.nix { inherit pkgs; };

  zshPkgs = import ./zsh/pkgs.nix { inherit pkgs; };

  pandocPkgs = import ./pandoc/pkgs.nix { inherit pkgs; };

  commonTools = import ./commonTools.nix { inherit pkgs; };
in
rustPkgs ++ mdbookPkgs ++ nixPkgs ++ zshPkgs ++ pandocPkgs ++ commonTools
