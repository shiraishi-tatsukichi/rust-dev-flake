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
              zshPath = "${pkgs.zsh}/bin/zsh";
            in

            pkgs.mkShell {
              name = "my-devshell";
              inherit packages LOCALE_ARCHIVE;
              shellHook = ''
                export SHELL=${zshPath}
                exec $SHELL -l
              '';
            };

          fromToolchainFile = fenix.packages.${system}.fromToolchainFile;
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
