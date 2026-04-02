{
  pkgs,
}:
{
  rust = { toolchain }: import ./rust/pkgs.nix { inherit toolchain pkgs; };

  mdbook = import ./mdbook/pkgs.nix { inherit pkgs; };

  internalDocs =
    {
      toolchain,
      craneLib,
      src,
      bookPath,
      pname,
      version,
    }:
    let
      # ドキュメントの成果物
      docs = import ./internal-docs/default.nix {
        inherit
          toolchain
          craneLib
          pkgs
          src
          bookPath
          pname
          version
          ;
      };
      dockerImage = import ./internal-docs/docker.nix {
        inherit pkgs docs;
      };
    in
    {
      inherit docs dockerImage;
    };

  nix = import ./nix/pkgs.nix { inherit pkgs; };

  zsh = import ./zsh/pkgs.nix { inherit pkgs; };

  pandoc = import ./pandoc/pkgs.nix { inherit pkgs; };

  common = import ./common/pkgs.nix { inherit pkgs; };

  minimum = import ./minimum/pkgs.nix { inherit pkgs; };

}
