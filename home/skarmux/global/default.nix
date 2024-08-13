{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
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

    packages = with pkgs; [
      uutils-coreutils
      vimv-rs
      fzf
      du-dust # disk usage analyzer
      ripgrep
      jq 
      grc # Semantic coloring of stdout
      tealdeer

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
      
      extraConfig = {
        XDG_REPO_DIR = "${config.home.homeDirectory}/Repositories"; 
      };

      createDirectories = true;
    };
  };
}
