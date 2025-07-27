{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.stylix.homeModules.stylix
    ./common/ghostty.nix
    ./common/git
    # ./common/gpg.nix
    ./common/helix
    ./common/llm
    ./common/shell
    ./common/starship.nix
    ./common/hyprland.nix
    ./common/alacritty.nix
  ]
  ++ builtins.attrValues self.homeModules;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "unrar"
  ];

  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "25.05";
  };

  programs = {
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = "tmux";
    };
    starship.enable = true;
  };

  # catppuccin = {
  #   enable = true; # global
  #   flavor = "frappe";
  #   accent = "blue";
  # };

  stylix = {
    enable = true;
    autoEnable = true;
    # Find all available themes here:
    # https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    opacity = {
      desktop = 0.8;
      applications = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };
    # List all available font family names with `fc-list`
    fonts = {
      serif = config.stylix.fonts.sansSerif;
      # {
      #   package = pkgs.dejavu_fonts;
      #   name = "DejaVu Serif";
      # };

      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Propo";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-mono;
        name = "FiraCode Nerd Font Propo";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        desktop = 10;
        popups = 18;
        terminal = 18;
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  sops = {
    age.keyFile = "/home/skarmux/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    validateSopsFiles = true;
  };
}
