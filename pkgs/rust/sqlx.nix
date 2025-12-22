{
  rustPlatform,
  pkgs,
}:

rustPlatform.buildRustPackage {
  pname = "sqlx-cli";
  version = "0.9.0-alpha";
  src = pkgs.fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    rev = "v0.9.0-alpha";
    hash = "sha256-Trnyrc17KWhX8QizKyBvXhTM7HHEqtywWgNqvQNMOAY=";
  };
  cargoBuildFlags = [ "--package sqlx-cli" ];
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
  cargoHash = "sha256-FxvzCe+dRfMUcPWA4lp4L6FJaSpMiXTqEyhzk+Dv1B8=";
  doCheck = true;
}
