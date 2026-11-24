# はじめに

このドキュメントは `dev-flake` を利用して `mdbook` をビルドするためのサンプルです。

```mermaid
graph TD
    A[Markdown ソース] -->|mdbook build| B[HTML 成果物]
    B -->|Nginx| C[Web 配信]
```
