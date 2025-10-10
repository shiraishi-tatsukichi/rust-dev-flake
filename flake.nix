{
  description = "rust 開発用 Nix ライブラリー";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { fenix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      fenixPkgs = fenix.packages.${system};

      toolchain = fenixPkgs.fromToolchainFile {
        file = ./rust-toolchain.toml;
        sha256 = "sha256-GCGEXGZeJySLND0KU5TdtTrqFV76TF3UdvAHSUegSsk=";
      };

      rustPlatform = pkgs.makeRustPlatform {
        cargo = toolchain;
        rustc = toolchain;
      };

      mdbook-pandoc = import ./pkgs/mdbook-pandoc.nix {
        inherit rustPlatform pkgs;
      };

      rustPkgs = [
        toolchain
        pkgs.cargo-leptos
        pkgs.leptosfmt
        pkgs.wasm-bindgen-cli
        pkgs.stylance-cli
        pkgs.sass
      ];

      mdbookPkgs = [
        pkgs.mdbook
        pkgs.mdbook-mermaid
        pkgs.mdbook-pdf
        mdbook-pandoc
      ];

      nixPkgs = with pkgs; [
        nixd
        nixfmt-rfc-style
        nix-tree
      ];

      commonTools = with pkgs; [
        git
        pkg-config
        google-cloud-sdk
        glibcLocales
        zenith
        pandoc
      ];

      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

    in
    rec {
      packages = rustPkgs ++ mdbookPkgs ++ nixPkgs ++ commonTools;
      devShells.${system}.default = pkgs.mkShell {
        name = "rust-nightly-devshell";
        inherit packages LOCALE_ARCHIVE;
        # shellHook = ''
        #   echo "Welcome to the Nix devShell!"
        # '';
      };
    };
}
