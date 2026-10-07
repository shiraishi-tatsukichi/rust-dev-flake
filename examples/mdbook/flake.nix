{
  description = "dev-flake を使用した mdbook ビルドのサンプル Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dev-flake.url = "path:../../";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      dev-flake,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        devPkgs = dev-flake.lib.${system};
      in
      {
        # 開発シェル: `nix develop` で mdbook や各種プラグインが使える環境に入ります
        devShells.default = pkgs.mkShell {
          packages = devPkgs.mdbook;
        };

        # ビルド成果物: `nix build` で HTML を出力します
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "example-book";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = devPkgs.mdbook;

          buildPhase = ''
            echo "Building mdbook..."
            mdbook build . -d $out
          '';

          installPhase = "true";
        };
      }
    );
}
