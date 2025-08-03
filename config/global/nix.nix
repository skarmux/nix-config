{ lib, ... }:
{
  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };

    settings = {
      allowed-users = [ "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      warn-dirty = false;
      experimental-features = "nix-command flakes";
      substituters = [
        "https://nix-community.cachix.org"
        # "https://cache.skarmux.tech"
      ];
      trusted-users = [ ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.skarmux.tech:IkJHXpLsX5SxtSiBjkQ+MZzjR5ZImNV/wiItHTYSjV0="
      ];
    };
  };

  nixpkgs.config = {
    permittedInsecurePackages = [
      "dotnet-runtime-7.0.20" # VintageStory
    ];
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "unrar"
      "keymapp"
      "vintagestory" # VintageStory
      "dotnet-runtime-7.0.20" # VintageStory
      "steam"
      "steam-unwrapped"
      "vscode"
    ];
  };
}