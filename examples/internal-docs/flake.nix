{
  description = "cargo doc と mdbook を Nginx OCI コンテナイメージとしてまとめて配信するサンプル Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    dev-flake.url = "path:../../";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      crane,
      dev-flake,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        craneLib = crane.mkLib pkgs;
        devPkgs = dev-flake.lib.${system};

        # ドキュメント（mdbook + cargo doc）の結合 Derivation
        docs =
          let
            # Rust ソースコード (.md ファイルを含む)
            cargoSrc = pkgs.lib.cleanSourceWith {
              src = craneLib.path ./.;
              filter = path: type: (craneLib.filterCargoSources path type) || (pkgs.lib.hasSuffix ".md" path);
            };

            # cargo doc の生成
            cargoDoc = craneLib.cargoDoc {
              src = cargoSrc;
              cargoExtraArgs = "--no-deps";
            };

            # mdbook の生成
            mdbookBuild = pkgs.stdenv.mkDerivation {
              pname = "internal-mdbook";
              version = "0.1.0";
              src = ./docs;
              nativeBuildInputs = devPkgs.mdbook;
              buildPhase = "mdbook build . -d $out";
              installPhase = "true";
            };
          in
          pkgs.stdenv.mkDerivation {
            pname = "internal-docs";
            version = "0.1.0";
            phases = [ "installPhase" ];
            installPhase = ''
              mkdir -p $out/share/nginx/html

              # mdbook の成果物をルートに配置
              cp -r ${mdbookBuild}/* $out/share/nginx/html/

              # cargo doc の成果物を /api に配置
              mkdir -p $out/share/nginx/html/api
              cp -r ${cargoDoc}/share/doc/* $out/share/nginx/html/api/
            '';
          };

        # Nginx コンテナイメージ (OCI Image) の構築
        nginxConfig = pkgs.writeText "nginx.conf" (
          builtins.replaceStrings [ "@nginx@" "@docs@" ] [ "${pkgs.nginx}" "${docs}" ] (
            builtins.readFile ./nginx.conf
          )
        );

        userContents = pkgs.runCommand "user-contents" { } ''
          mkdir -p $out/etc
          echo "nginx:x:1000:1000:Nginx user:/var/empty:/bin/sh" > $out/etc/passwd
          echo "nginx:x:1000:" > $out/etc/group
        '';
      in
      {
        # 静的ドキュメント成果物
        packages.docs = docs;

        # OCI コンテナイメージ: `nix build .#dockerImage`
        packages.dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "internal-docs";
          tag = "latest";

          contents = [
            pkgs.nginx
            pkgs.fakeNss
            userContents
          ];

          extraCommands = ''
            mkdir -p tmp/nginx_client_body
            mkdir -p var/log/nginx
            mkdir -p var/cache/nginx
            chmod -R 1777 tmp var/log/nginx var/cache/nginx
          '';

          config = {
            Cmd = [
              "${pkgs.nginx}/bin/nginx"
              "-c"
              "${nginxConfig}"
            ];
            ExposedPorts = {
              "8080/tcp" = { };
            };
            User = "1000:1000";
          };
        };

        packages.default = self.outputs.packages.${system}.dockerImage;
      }
    );
}
