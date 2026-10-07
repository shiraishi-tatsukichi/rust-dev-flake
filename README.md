# dev-flake

Rust 開発およびドキュメント作成に必要なツールチェイン・ライブラリを提供する Nix Flake ライブラリです。

## 📦 提供しているパッケージ群 (`pkgs/`)

- **`rust`**: Rust ツールチェイン, `sccache`, `cargo-make`, `cargo-leptos`, `sqlx-cli` など
- **`mdbook`**: `mdbook` および各種プラグイン (`mdbook-mermaid`, `mdbook-pandoc`, `mdbook-pdf`)
- **`nix`**: Nix 開発支援ツール (`nixd`, `nixfmt`, `nix-tree`)
- **`pandoc`**: `pandoc`
- **`tree-sitter`**: `tree-sitter` CLI & Node.js
- **`minimum`**: ネイティブビルド依存 (`pkg-config`, `openssl`, `glibcLocales`)

## 💡 使い方

各プロジェクトの `flake.nix` から `dev-flake` をインポートして使用します。

### 開発シェルの構築 (`mkDevShell`)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dev-flake.url = "github:your-org/dev-flake"; # またはローカルパス
  };

  outputs = { self, nixpkgs, dev-flake }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      devPkgs = dev-flake.lib.${system};
    in
    {
      devShells.default = devPkgs.mkDevShell {
        packages = devPkgs.minimum ++ devPkgs.rust { toolchain = ...; };
      };
    };
}
```

## 📚 サンプルコード (`examples/`)

- [`examples/mdbook/`](./examples/mdbook/): `mdbook` を使用したドキュメント開発・ビルドの最小サンプル構成
