{
  programs.wezterm = {
    extraConfig = /* lua */ ''
      return {
        font_size = 12.0,
        color_scheme = "Catppuccin Mocha",
        enable_wayland = true,
        enable_tab_bar = false,
      }
    '';
  };
}
