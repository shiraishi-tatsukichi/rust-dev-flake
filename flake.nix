{
  description = "rust 開発用 Nix ライブラリー";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, fenix,  ... }:
    let
      system = "x86_64-linux";
      fenixPkgs = fenix.packages.${system};

      toolchain = fenixPkgs.fromToolchainFile {
        file = ./rust-toolchain.toml;
        sha256 = "sha256-P39FCgpfDT04989+ZTNEdM/k/AE869JKSB4qjatYTSs=";
      };
    in
    rec {
      lib = {
        mkDevShell =
          { system, toolchain }:
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
      devShells.${system}.default = lib.mkDevShell { inherit system toolchain; };
    };
}
