{ toolchain, pkgs }:
let
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
  mdbook-codename = import ./codename.nix {
    inherit rustPlatform pkgs;
  };
  mdbook-metadata = import ./metadata.nix {
    inherit rustPlatform pkgs;
  };
in
[
  pkgs.mdbook
  pkgs.mdbook-mermaid
  pkgs.mdbook-pdf
  pkgs.pandoc
  pkgs.texliveSmall
  mdbook-codename
  mdbook-metadata
  pkgs.mdbook-pandoc
]
