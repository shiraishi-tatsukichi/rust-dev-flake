{
  pkgs,
}:
{
  rust = { toolchain }: import ./rust { inherit toolchain pkgs; };

  mdbook = import ./mdbook { inherit pkgs; };

  nix = import ./nix { inherit pkgs; };

  pandoc = import ./pandoc { inherit pkgs; };

  tree-sitter = import ./tree-sitter { inherit pkgs; };

  minimum = import ./minimum { inherit pkgs; };
}
