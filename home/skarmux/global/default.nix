{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    inputs.nixvim.homeManagerModules.nixvim
    inputs.hyprlock.homeManagerModules.hyprlock
    ./zellij
    ./direnv.nix
    ./bash.nix
    ./nix.nix
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./yazi.nix
    ./git.nix
    ./starship.nix
    ./btop.nix
    ./neovim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # Everything without a program.* option
  home.packages = with pkgs; [
    #vimv # replaced by yazi
    #tree # replaced by eza
    unzip
    fzf

    # Decoration
    cmatrix
    asciiquarium
    tty-clock

    du-dust # disk usage analyzer
    mprocs # TODO: zellij comparison 
    ripgrep
    speedtest-rs
    wiki-tui
    slides

    # Cross-platform Rust rewrite of the GNU coreutils
    uutils-coreutils
  ];

  # TODO: Add explanation of `sd-switch`
  systemd.user.startServices = "sd-switch";

  home = {
    username = lib.mkDefault "skarmux";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
  };

  # Catppuccin colorscheme settings
  catppuccin = {
    enable = true; # Apply to all available applications
    flavour = "mocha";
    accent = "mauve";
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;

    createDirectories = true;

    # Disable unwanted dirs
    #desktop = null;
    #publicShare = null;
    #templates = null;

    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
    };
  };
}
