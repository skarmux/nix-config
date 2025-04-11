{ lib, config, ... }:
{
  nixpkgs.config = {
    # cache.nixos.org does not process unfree packages which
    # requires the host to build them
    allowUnfree = false;
    # This way, I have an overview over the non-free packages I use
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "discord"
      "nvidia-x11"
      "unrar"
      "plexamp"
      "makemkv"
      "davinci-resolve"
      "obsidian"
      "steam"
      "steam-unwrapped" # For adding Proton-GE
      "nvidia-settings"
    ];
  };

  nix = {
    # Serve the nix store binaries to other network clients
    sshServe = {
      enable = lib.mkDefault false;
      keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOHnEYhX+q+xTVjoIIAjT+tn1NVAtqLjkE8J88YS14w skarmux" ];
      protocol = "ssh";
      # Whether to enable writing to the Nix store as a remote store via SSH. 
      # Note: the sshServe user is named nix-ssh and is not a trusted-user. 
      # nix-ssh should be added to the nix.settings.trusted-users option in 
      # most use cases, such as allowing remote building of derivations.
      write = true;
    };

    gc = {
      automatic = lib.mkDefault false;
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
        "https://cache.skarmux.tech"
      ];
      trusted-users = [ ] ++ (lib.optionals config.nix.sshServe.enable [ "nix-ssh" ]);
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.skarmux.tech:IkJHXpLsX5SxtSiBjkQ+MZzjR5ZImNV/wiItHTYSjV0="
      ];
    };
  };
}
