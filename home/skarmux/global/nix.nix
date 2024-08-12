{ outputs, lib, pkgs, ... }:
{
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  nix = {

    package = lib.mkDefault pkgs.nix;

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = "nix-command flakes";
    };
  };
}
