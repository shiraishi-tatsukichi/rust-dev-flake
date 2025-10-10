{ rustPlatform, pkgs }:

rustPlatform.buildRustPackage {
  pname = "mdbook-pandoc";
  version = "0.10.5";
  src = pkgs.fetchFromGitHub {
    owner = "max-heller";
    repo = "mdbook-pandoc";
    rev = "v0.10.5";
    hash = "sha256-ihKju9XXJy4JciuMLw4EcKhqSQjrBiUJDG0Rd5DbFdk=";
  };
  cargoHash = "sha256-SXXzGOBvfyLYhed5EMFUCzkFWoGEMM73PD3uWjkUcic=";
  doCheck = false;
}
