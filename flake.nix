{
  description = "rust 開発用 Nix ライブラリー";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: rec {
      lib =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        import ./pkgs/pkgs.nix { inherit pkgs; }
        // {
          mkDevShell =
            {
              packages ? lib.minimum,
            }:
            let
              LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
            in

            pkgs.mkShell {
              name = "my-devshell";
              env = {
                RUSTC_WRAPPER="${pkgs.sccache}/bin/sccache";
              };
              inherit packages LOCALE_ARCHIVE;
            };
        };
      devShells =
        let
          packages = lib.minimum ++ lib.nix;
        in
        {
          default = lib.mkDevShell { inherit packages; };
        };
    });
}
