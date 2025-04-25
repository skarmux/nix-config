{ lib, config, ... }:
{
  nixpkgs.config = {
    # cache.nixos.org does not process unfree packages which
    # requires the host to build them
    # Not sure about the cachix cache though...

    allowUnfree = lib.mkForce false;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "davinci-resolve"
      "discord"
      "makemkv"
      "nvidia-settings"
      "nvidia-x11"
      "obsidian"
      "plexamp"
      "steam"
      "steam-unwrapped" # For adding Proton-GE
      "unrar"

      # Microsoft True Type Fonts
      # Arial
      # Comic Sans
      # Courier New
      # Georgia
      # Impact
      # Tahoma
      # Times New Roman
      # Trebuchet
      # Verdana
      # Webdings
      "corefonts" 

      # Microsoft True Type Fonts (Windows Vista)
      # Calibri
      # Cambria
      # Candara
      # Consolas
      # Constantia
      # Corbel
      "vista-fonts"
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
