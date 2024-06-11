{ pkgs, ... }:
{
  home.sessionVariables.TERMINAL = "${pkgs.wezterm}/bin/wezterm";
  programs.wezterm = {
    enable = true;
    extraConfig = /* lua */ ''
      return {
        font_size = 12.0,
        color_scheme = "Catppuccin Mocha",
        enable_wayland = false,
        enable_tab_bar = false,
      }
    '';
  };
}
