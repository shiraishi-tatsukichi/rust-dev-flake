{ toolchain, pkgs }:
[
  toolchain
  pkgs.cargo-leptos
  pkgs.leptosfmt
  pkgs.wasm-bindgen-cli
  pkgs.stylance-cli
  pkgs.sass
]
