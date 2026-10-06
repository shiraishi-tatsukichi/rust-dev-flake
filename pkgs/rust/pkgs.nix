{ toolchain, pkgs }:
[
  toolchain
  pkgs.cargo-expand
  pkgs.cargo-make
  pkgs.cargo-leptos
  pkgs.cargo-insta
  pkgs.leptosfmt
  pkgs.stylance-cli
  pkgs.sass
  pkgs.sqlx-cli
  pkgs.sqlite
]
