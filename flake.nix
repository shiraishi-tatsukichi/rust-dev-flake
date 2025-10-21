{
  description = "rust 開発用 Nix ライブラリー";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    {
      lib = {
        mkDevShell =
          { system, toolchain }:
          let
            pkgs = import nixpkgs { inherit system; };

            packages = import ./pkgs/pkgs.nix { inherit toolchain pkgs; };

            LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
          in
          pkgs.mkShell {
            name = "rust-nightly-devshell";
            inherit packages LOCALE_ARCHIVE;
          };
      };
    };
}
