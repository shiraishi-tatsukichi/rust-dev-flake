# mdbook Example with dev-flake

このサンプルディレクトリは、`dev-flake` の mdbook パッケージ（`mdbook` ＋ プラグイン群）を利用してドキュメントの開発・ビルドを行う最小構成例です。

## 📁 ディレクトリ構成

```text
examples/mdbook/
├── flake.nix        # dev-flake を読み込んで開発シェルとビルドを定義
├── book.toml        # mdbook の設定ファイル
├── README.md        # このドキュメント
└── src/
    ├── SUMMARY.md   # 目次構成
    └── chapter_1.md # サンプルページ
```

## 🚀 使い方

### 1. 開発シェルの起動 (`nix develop`)

ローカルに `mdbook` や関連プラグイン（`mdbook-mermaid` や `mdbook-pandoc` 等）がインストールされていなくても、以下のコマンドで環境に入れます。

```bash
cd dev-flake/examples/mdbook
nix develop
```

シェル内でドキュメントのローカルプレビューを実行できます：

```bash
mdbook serve --open
```

### 2. ドキュメントのビルド (`nix build`)

Nix を使って再現可能な静的 HTML 成果物をビルドします。

```bash
nix build ./dev-flake/examples/mdbook
```

ビルドが成功すると、`result/` ディレクトリ（シンボリックリンク）内に HTML / JS / CSS 成果物が出力されます。

```bash
ls -la result/
# index.html, chapter_1.html などが出力されています
```
