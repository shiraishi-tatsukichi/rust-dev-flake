{
  rustPlatform,
  pkgs,
}:

rustPlatform.buildRustPackage {
  pname = "sqlx-cli";
  version = "0.8.6";
  src = pkgs.fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "0.8.6";
    hash = "sha256-Po1Jc1eiuIhsBIHNcI5n6cjl2nfcU7TGzAaCx4iGMCc=";
  };
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "completions"
    "postgres"
    "sqlite"
    "rustls"
  ];
  nativeBuildInputs = [
    pkgs.pkg-config
  ];
  cargoHash = "sha256-6yn/hPG7sO7Sh8JtkX9oJET9iBGsl/Fb9eJuZelBQdA=";
  doCheck = true;
}
