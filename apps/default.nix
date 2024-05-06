{ pkgs, ... }:
{
  default = import ./help.nix { inherit pkgs; };

  format = import ./format.nix { inherit pkgs; };
  mount = import ./mount.nix { inherit pkgs; };
  install = import ./install.nix { inherit pkgs; };
}
