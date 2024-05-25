{ config, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = /* lua */ ''
      return {
        font_size = 14.0,
        color_scheme = "Catppuccin Mocha",
      }
    '';
  };
}
