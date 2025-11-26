{ toolchain, pkgs }:
let
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
  sqlx = import ./sqlx.nix {
    inherit rustPlatform pkgs;
  };
in
[
  toolchain
  pkgs.cargo-leptos
  pkgs.leptosfmt
  pkgs.wasm-bindgen-cli
  pkgs.stylance-cli
  pkgs.sass
  sqlx
  pkgs.sqlite
]
