{
  pkgs,
  craneLib,
  src,
  bookPath,
  pname,
  version,
}:
let
  # 1. Rustプロジェクトのソースをフィルタリング (.md ファイルを include_str! しているため含める)
  cargoSrc = pkgs.lib.cleanSourceWith {
    src = craneLib.path src;
    filter = path: type: (craneLib.filterCargoSources path type) || (pkgs.lib.hasSuffix ".md" path);
  };

  # 2. Rust依存関係のビルド（キャッシュ用）
  cargoArtifacts = craneLib.buildDepsOnly {
    src = cargoSrc;
    inherit pname version;
    doCheck = false;
  };

  # 3. cargo doc のビルド（APIドキュメント）
  cargo-doc = craneLib.cargoDoc {
    src = cargoSrc;
    inherit cargoArtifacts version pname;
    cargoDocExtraArgs = "--no-deps";
  };

  # 4. mdbook のビルド (../mdbook/default.nix の定義を利用)
  mdbook-build = import ../mdbook {
    inherit pkgs pname version;
    # bookPath ディレクトリそのものをソースとして渡す
    src = craneLib.path "${src}/${bookPath}";
  };
in
pkgs.stdenv.mkDerivation {
  # 最終成果物の名前を識別しやすく -internal-docs を付与
  pname = "${pname}-internal-docs";
  inherit version;

  # すでにビルド済みの Derivation の成果物を集約するだけなので、軽量な installPhase のみ
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/nginx/html

    # mdbook の成果物をコピー
    cp -r ${mdbook-build}/* $out/share/nginx/html/

    # cargo doc の成果物をコピー
    mkdir -p $out/share/nginx/html/api
    # $cargo-doc は derivation なので、そのパス配下を参照
    cp -r ${cargo-doc}/share/doc/* $out/share/nginx/html/api/
  '';
}
