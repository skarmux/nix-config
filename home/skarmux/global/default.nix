{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    inputs.nixvim.homeManagerModules.nixvim
    inputs.hyprlock.homeManagerModules.hyprlock
    ./zellij
    ./direnv.nix
    # ./bash.nix
    ./sops.nix
    ./nix.nix
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./gnupg.nix
    ./ssh.nix
    ./git.nix
    ./starship.nix
    ./btop.nix
    ./neovim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs = {
    home-manager.enable = true;
  };

  # Everything without a program.* option
  home.packages = with pkgs; [
    vimv # basically oil.nvim with nested edits
    tree
    unzip
    fzf

    # Yubikey
    yubikey-personalization
    yubikey-manager
    yubikey-agent

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
  catppuccin.flavour = "mocha";
  catppuccin.accent = "mauve";

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  # Allow Nix to manage default application list
  xdg.enable = true;
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;

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
