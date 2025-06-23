{ inputs, self, pkgs, config, ... }:
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
  ]
  ++ builtins.attrValues self.homeModules;
  
  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "24.11";
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

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
  stylix.fonts = {
    serif = config.stylix.fonts.sansSerif;
    # {
    #   package = pkgs.dejavu_fonts;
    #   name = "DejaVu Serif";
    # };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "Fira Code";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "Fira Code Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 12;
      desktop = 10;
      popups = 10;
      terminal = 12;
    };
  };

  systemd.user.startServices = "sd-switch";

  sops = {
    age.keyFile = "/home/skarmux/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    validateSopsFiles = true;
  };
}
