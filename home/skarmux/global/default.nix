{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    # inputs.nixvim.homeManagerModules.nixvim
    # inputs.sops-nix.homeManagerModules.sops
    ./direnv.nix
    ./nix.nix
    ./git
    ./bash.nix
    # ./fish.nix
    # ./zellij
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
    ./eza.nix
    ./starship.nix
    # ./sops.nix
    ./btop.nix
    # ./nushell.nix
  ];
  # ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    ssh.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "24.05";

    username = lib.mkDefault "skarmux";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    packages = with pkgs; [
      uutils-coreutils
      fzf # file finder
      du-dust # disk usage analyzer
      ripgrep # full-text search
      jq # json
      yq # yaml and json
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
      createDirectories = lib.mkDefault true;
    };
  };
}
