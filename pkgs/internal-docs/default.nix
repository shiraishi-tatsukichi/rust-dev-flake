{
  pkgs,
  toolchain,
  craneLib,
  src,
  bookPath,
  pname,
  version,
}:
let
  # Rustプロジェクトのソースをフィルタリング (.md ファイルを include_str! しているため含める)
  cargoSrc = pkgs.lib.cleanSourceWith {
    src = craneLib.path src;
    filter = path: type: (craneLib.filterCargoSources path type) || (pkgs.lib.hasSuffix ".md" path);
  };

  # 1. 依存関係のビルド（キャッシュ用）
  cargoArtifacts = craneLib.buildDepsOnly {
    src = cargoSrc;
    inherit pname version;
    doCheck = false;
  };

  # 2. cargo doc のビルド
  cargo-doc = craneLib.cargoDoc {
    src = cargoSrc;
    inherit cargoArtifacts pname version;
    cargoDocExtraArgs = "--no-deps";
  };
in
pkgs.stdenv.mkDerivation {
  inherit pname version;

  # ソース全体を取り込む
  inherit src;

  nativeBuildInputs = import ../mdbook/pkgs.nix { inherit pkgs; } ++ [
    toolchain
  ];

  buildPhase = ''
    # 1. mdbook のビルド
    echo "Building mdbook in: ${bookPath}"
    mdbook build "${bookPath}" -d $TMPDIR/book-out

    # 2. 成果物の集約
    mkdir -p $out/share/nginx/html

    # mdbook の成果物をコピー
    cp -r $TMPDIR/book-out/* $out/share/nginx/html/

    # cargo doc の成果物をコピー
    # craneLib.cargoDoc の成果物は通常 $out/share/doc に格納されます
    mkdir -p $out/share/nginx/html/doc
    # $cargo-doc は derivation なので、そのパス配下を参照
    cp -r ${cargo-doc}/share/doc/* $out/share/nginx/html/doc/
  '';

  # installPhase は buildPhase で $out に書き出しているため空でOK
  installPhase = "true";
}
