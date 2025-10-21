{
  rustPlatform,
  pkgs,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-codename";
  version = "0.0.1";
  src = pkgs.fetchFromGitHub {
    owner = "smallkirby";
    repo = "mdbook-codename";
    rev = "0.0.1";
    hash = "sha256-Po1Jc1eiuIhsBIHNcI5n6cjl2nfcU7TGzAaCx4iGMCc=";
  };
  nativeBuildInputs = [
    pkgs.pkg-config
  ];
  cargoHash = "sha256-6yn/hPG7sO7Sh8JtkX9oJET9iBGsl/Fb9eJuZelBQdA=";
  doCheck = true;
}
