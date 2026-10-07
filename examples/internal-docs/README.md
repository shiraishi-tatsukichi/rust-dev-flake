# Internal Docs Container Example

このサンプルディレクトリは、`crane` による Rust の API ドキュメント（`cargo doc`）と `mdbook` のドキュメントを結合し、非特権 Nginx 上で静的配信する OCI コンテナイメージをビルドする構成例です。

## 📁 ディレクトリ構成

```text
examples/internal-docs/
├── flake.nix    # crane + mdbook + nginx OCI イメージ構築の定義
├── nginx.conf   # 非ルートユーザー(UID:1000)用の Nginx 設定
└── README.md    # このドキュメント
```

## 🚀 使い方

### 1. 静的ドキュメントのビルド (`nix build .#docs`)

`cargo doc` と `mdbook` をまとめて静的 HTML フォルダとして出力します。

```bash
nix build ./dev-flake/examples/internal-docs#docs
```

### 2. OCI コンテナイメージのビルド (`nix build .#dockerImage`)

Nginx を含めた軽量コンテナイメージ（tarball）をビルドします。

```bash
nix build ./dev-flake/examples/internal-docs#dockerImage
docker load < result
docker run -p 8080:8080 internal-docs:latest
```

ブラウザで `http://localhost:8080` へアクセスすると mdbook が、`http://localhost:8080/api` へアクセスすると API ドキュメントが閲覧できます。
