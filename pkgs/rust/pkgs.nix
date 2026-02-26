{ toolchain, pkgs }:
[
  toolchain
  pkgs.cargo-leptos
  pkgs.cargo-insta
  pkgs.leptosfmt
  pkgs.wasm-bindgen-cli
  pkgs.stylance-cli
  pkgs.sass
  pkgs.sqlx-cli
  pkgs.sqlite
]
