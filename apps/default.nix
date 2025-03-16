{ pkgs, ... }:
{
  install = import ./install.nix { inherit pkgs; };
}
