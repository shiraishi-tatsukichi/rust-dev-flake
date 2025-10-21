{
  rustPlatform,
  pkgs,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-metadata";
  version = "0.1.1";
  src = pkgs.fetchFromGitHub {
    owner = "jeffersonroth";
    repo = "mdbook-metadata";
    rev = "v0.1.1";
    hash = "sha256-ihKju9XXJy4JciuMLw4EcKhqSQjrBiUJDG0Rd5DbFdk=";
  };
  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.texliveSmall
    pkgs.pandoc
  ];
  cargoHash = "sha256-SXXzGOBvfyLYhed5EMFUCzkFWoGEMM73PD3uWjkUcic=";
  doCheck = true;
}
