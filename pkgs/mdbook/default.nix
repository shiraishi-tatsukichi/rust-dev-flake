{
  pkgs,
  src,
  pname ? "internal-docs",
  version ? "0.1.0",
}:
pkgs.stdenv.mkDerivation {
  # プロジェクト名を受け取って -mdbook を付ける
  pname = "${pname}-mdbook";
  inherit version src;

  nativeBuildInputs = import ./pkgs.nix { inherit pkgs; };

  buildPhase = ''
    echo "Building ${pname} mdbook..."
    # src が bookPath そのものとして渡されることを想定
    mdbook build . -d $out
  '';

  installPhase = "true";
}
