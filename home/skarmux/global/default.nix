{ inputs, outputs, pkgs, lib, config, ... }:
let
  persistHomeDirectory = "/nix/persist/home/skarmux";
in
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./direnv.nix
    ./nix.nix
    ./ssh.nix
    ./git
    ./bash.nix
    ./fish.nix
    ./zellij
    ./yazi.nix
    ./eza.nix
    ./starship.nix
    ./btop.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs = {
    home-manager.enable = true;
    bat.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "24.05";

    username = lib.mkDefault "skarmux";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    persistence = {
      "${persistHomeDirectory}" = {
        directories = [
          {
            directory = "Downloads";
            method = "symlink";
          }
          {
            directory = "Repositories";
            method = "symlink";
          }
          {
            directory = "Documents";
            method = "symlink";
          }
          {
            directory = ".local/bin";
            method = "symlink";
          }
          {
            directory = ".local/share/nix";
            method = "symlink";
          }
        ];
        # allow users such as root to see home directories
        allowOther = true;
      };
    };

    packages = with pkgs; [
      uutils-coreutils
      vimv-rs
      fzf
      du-dust # disk usage analyzer
      ripgrep
      jq 
      grc 

      # Compression
      p7zip 
      unzip
      unrar 
    ];
  };

  # Theming
  catppuccin = {
    enable = true; # Apply to all available applications
    flavor = "mocha";
    accent = "mauve";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      
      publicShare = "${persistHomeDirectory}/PublicShare";
      templates = "${persistHomeDirectory}/Templates";
      videos = "${persistHomeDirectory}/Videos";
      music = "${persistHomeDirectory}/Music";
      pictures = "${persistHomeDirectory}/Pictures";
      desktop = "${persistHomeDirectory}/Desktop";
      documents = "${persistHomeDirectory}/Documents";
      download = "${persistHomeDirectory}/Downloads";

      extraConfig = {
        XDG_REPO_DIR = "${persistHomeDirectory}/Repositories"; 
      };

      createDirectories = true;
    };
  };
}
