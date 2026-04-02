{
  pkgs,
  toolchain,
  src,
  bookPath,
}:
pkgs.stdenv.mkDerivation {
  pname = "internal-docs";
  version = "0.1.0";

  # ソース全体を Nix Store に取り込む
  inherit src;

  nativeBuildInputs = [
    pkgs.mdbook
    toolchain
  ];

  buildPhase = ''
    # 1. mdbook のビルド
    # bookPath を使ってディレクトリを指定
    echo "Building mdbook in: ${bookPath}"
    mdbook build "${bookPath}" -d $TMPDIR/book-out

    # 2. cargo doc のビルド
    # (Rustプロジェクトのルートで実行することを想定)
    cargo doc --no-deps --target-dir $TMPDIR/cargo-out

    # 3. 成果物の集約
    mkdir -p $out/share/nginx/html
    cp -r $TMPDIR/book-out/* $out/share/nginx/html/
    cp -r $TMPDIR/cargo-out/doc/* $out/share/nginx/html/doc/
  '';
}
