{ 
  lib,
  pkgs,
  config,
  inputs, # external modules
  outputs, # custom modules
  ...
}:
{
    imports = [
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.sops-nix.homeManagerModules.sops
      inputs.impermanence.nixosModules.home-manager.impermanence

      ./helix
      ./git

      ./direnv.nix
      ./btop.nix
      ./starship.nix
      ./tmux.nix
      ./yazi.nix
      ./zoxide.nix
      ./eza.nix

      # shells
      ./fish.nix
      ./bash.nix
      ./nushell.nix
    ] ++ (builtins.attrValues outputs.homeManagerModules);

    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config.allowUnfree = true;
    };

    nix = {
      package = pkgs.nix;
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

    home.username = "skarmux";
    home.homeDirectory = "/home/skarmux"; # TODO persistence?

    home.persistence = {
      "/nix/persist/${config.home.homeDirectory}" = {
        defaultDirectoryMethod = "symlink";
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
        ];
        allowOther = true;
      };
    };

    programs.home-manager.enable = true; # for home-manager switch command
    programs.git.enable = true;
    programs.bat.enable = true; # `cat` replacement
    programs.ssh.enable = true; # enable ssh for this user
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

    home.stateVersion = "24.05";
 }
