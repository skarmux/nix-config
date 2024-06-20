{ config
, lib
, default ? false
, ...
}:
{
  home.sessionVariables.TERMINAL = lib.mkIf default "${config.programs.wezterm.package}/bin/alacritty";

  # TODO: Opening multiple instances of wezterm
  #       causes it to slow down to a crawl :(
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
