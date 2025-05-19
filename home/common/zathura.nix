{ lib, ... }:
{
  programs.zathura = {
    options = {
      # Keep pdf visuals as-is and don't let
      # catppuccin nix modules set this to true
      recolor = lib.mkForce false;
    };
  };
}
