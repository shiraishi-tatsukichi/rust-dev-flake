{
  description = "rust 開発用 Nix ライブラリー";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      flake-utils,
      fenix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: rec {
      lib = {
        mkDevShell =
          { toolchain }:
          let
            pkgs = import nixpkgs { inherit system; };

            packages = import ./pkgs/pkgs.nix { inherit toolchain pkgs; };

            LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
            zshPath = "${pkgs.zsh}/bin/zsh";
          in
          pkgs.mkShell {
            name = "rust-nightly-devshell";
            inherit packages LOCALE_ARCHIVE;
            shellHook = ''
              export SHELL=${zshPath}
              exec $SHELL -l
            '';
          };
      };
      devShells =
        let
          fenixPkgs = fenix.packages.${system};

          toolchain = fenixPkgs.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-WInuoEKQQy+RPFLGMp0sLDxCzFKfiixAE6s1ssLYxcc=";
          };
        in
        {
          default = lib.mkDevShell { inherit toolchain; };
        };
    });
}
