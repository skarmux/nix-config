{ lib, config, ... }:
{
  nixpkgs.config = {
    # cache.nixos.org does not process unfree packages which
    # requires the host to build them
    # Not sure about the cachix cache though...

    allowUnfree = lib.mkForce false;
    permittedInsecurePackages = [
      # Vintage Story
      "dotnet-runtime-7.0.20"
    ];
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "davinci-resolve"
      "discord-ptb"
      "makemkv"
      "nvidia-settings"
      "nvidia-x11"
      "obsidian"
      "plexamp"
      "steam"
      "steam-unwrapped" # For adding Proton-GE
      "unrar"
      "keymapp"
      "minecraft-launcher"

      # Vintage Story
      "vintagestory"
      "dotnet-runtime-7.0.20"

      # Retroarch
      "libretro-snes9x"

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
      "vscode"
    ];
  };

  nix = {
    # Serve the nix store binaries to other network clients
    sshServe = {
      enable = lib.mkDefault false;
      keys = [
        (builtins.readFile ../../nixos/ignika/ssh_host_ed25519_key.pub)
      ];
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
        # "https://cache.skarmux.tech"
      ];
      trusted-users = [ ] ++ (lib.optionals config.nix.sshServe.enable [ "nix-ssh" ]);
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.skarmux.tech:IkJHXpLsX5SxtSiBjkQ+MZzjR5ZImNV/wiItHTYSjV0="
      ];
    };
  };
}
