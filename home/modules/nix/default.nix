{ inputs, opts, pkgs, lib, ... }:
{
  nix = {
    # Make it default for when the value is defined in nixos
    # configuration and home is merely embedded.
    package = lib.mkDefault pkgs.nix;
    
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = "nix-command flakes";
      show-trace = true;
      warn-dirty = false;
    };
  };
}
