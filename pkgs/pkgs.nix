{
  pkgs,
}:
{
  rust = { toolchain }: import ./rust/pkgs.nix { inherit toolchain pkgs; };

  mdbook = import ./mdbook/pkgs.nix { inherit pkgs; };

  nix = import ./nix/pkgs.nix { inherit pkgs; };

  zsh = import ./zsh/pkgs.nix { inherit pkgs; };

  pandoc = import ./pandoc/pkgs.nix { inherit pkgs; };

  common = import ./common/pkgs.nix { inherit pkgs; };

  minimum = import ./minimum/pkgs.nix { inherit pkgs; };

}
