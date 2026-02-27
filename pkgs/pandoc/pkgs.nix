{ pkgs }:
let
  pandoc = pkgs.stdenv.mkDerivation rec {
    pname = "pandoc-bin";
    version = "3.9"; # ここに欲しいバージョンを書く
    src = pkgs.fetchurl {
      url = "https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-linux-amd64.tar.gz";
      sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="; # nix-prefetch-url で取得
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp bin/pandoc $out/bin/
    '';
  };
in
[
  pandoc
]
