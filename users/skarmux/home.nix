{ lib, pkgs, config, inputs, outputs, ... }:
{
    imports = [
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.sops-nix.homeManagerModules.sops
      inputs.impermanence.homeManagerModules.impermanence
      ./helix
      ./git
      ./direnv.nix
      ./btop.nix
      ./starship.nix
      ./tmux.nix
      ./yazi.nix
      ./zoxide.nix
      ./eza.nix
      ./fish.nix
      ./bash.nix
      ./nushell.nix
    ] ++ (builtins.attrValues outputs.homeManagerModules);

    home.username = "skarmux";
    home.homeDirectory = "/home/skarmux"; # TODO persistence?

    nixpkgs.overlays = builtins.attrValues outputs.overlays;
    nixpkgs.config.allowUnfree = true;

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
        warn-dirty = false;
      };
    };

    programs = {
      home-manager.enable = true; # for home-manager switch command
      git.enable = true;
      bat.enable = true; # `cat` replacement
      # ssh.enable = true; # enable ssh for this user
    };
    home.packages = with pkgs; [
      fzf      # fuzzy file finder
      jq       # json parsing
      grc      # semantic coloring of stdout for non-themed output
      # compression libraries
      p7zip # 7z
      unzip # zip
      unrar # rar
    ];

    # Automatically restart systemd services on home-manager switch
    systemd.user.startServices = "sd-switch";

    catppuccin = {
      enable = true; # global
      flavor = "mocha";
      accent = "mauve";
    };

    home.persistence."/nix/persist/home/skarmux" = {
      defaultDirectoryMethod = "symlink";
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        ".gnupg"
        ".ssh"
        ".nixops"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".local/share/Steam"
        ".local/state/syncthing"
      ];
      files = [ ];
      allowOther = true;
    };

    home.stateVersion = "24.11";
 }
