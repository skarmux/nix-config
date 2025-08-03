{ pkgs, config, ... }:
{
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
}