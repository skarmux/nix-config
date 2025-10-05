{
  services.hyprpaper = {
    enable = true;
    settings = let
      directory = "/home/skarmux/Pictures/Wallpapers";
      miku = "__hatsune_miku_vocaloid_drawn_by_osamu_jagabata__9a0998477b6ac8007bd255899966a703_upscayl_4x_digital-art-4x.png";
      yoko = "CuVQq0LXEAAXiA1_upscayl_4x_realesrgan-x4plus-anime.png";
      bliss = "bliss-600dpi.png";
    in {
    
      # IPC (Inter Process Communication)
      # Pull configuration values from the hyprland config. Very cool
      # to switch wallpaper with shortcuts, for example when switching
      # workspaces. https://github.com/hyprwm/hyprpaper#ipc
      ipc = "off";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${directory}/${miku}"
      ];

      wallpaper = [
        # "DP-3,/share/wallpapers/buttons.png"
        # "DP-1,/share/wallpapers/cat_pacman.png"
        # FIXME: Pull `port` from monitors module. So, move hyprpaper up to nixos configuration.
        "DP-1,${directory}/${miku}"
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
        "hyprpaper"
    ];
  };

}