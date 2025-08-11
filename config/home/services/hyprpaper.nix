{ config, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
    
      # IPC (Inter Process Communication)
      # Pull configuration values from the hyprland config. Very cool
      # to switch wallpaper with shortcuts, for example when switching
      # workspaces. https://github.com/hyprwm/hyprpaper#ipc
      ipc = "off";
      splash = false;
      splash_offset = 2.0;

      preload = [
        # "/share/wallpapers/buttons.png"
        # "/share/wallpapers/cat_pacman.png"
        "/home/skarmux/Pictures/Wallpapers/CuVQq0LXEAAXiA1_upscayl_4x_realesrgan-x4plus-anime.png"
        "/home/skarmux/Pictures/Wallpapers/__hatsune_miku_vocaloid_drawn_by_osamu_jagabata__9a0998477b6ac8007bd255899966a703_upscayl_4x_digital-art-4x.png"
        "/home/skarmux/Pictures/Wallpapers/bliss-600dpi.png"
        "/home/skarmux/Pictures/Wallpapers/img0-RGB-scale-x2-000000.png"
      ];

      wallpaper = [
        # "DP-3,/share/wallpapers/buttons.png"
        # "DP-1,/share/wallpapers/cat_pacman.png"
        # FIXME: Pull `port` from monitors module. So, move hyprpaper up to nixos configuration.
        "DP-1,/home/skarmux/Pictures/Wallpapers/CuVQq0LXEAAXiA1_upscayl_4x_realesrgan-x4plus-anime.png"
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
        "hyprpaper"
    ];
  };

}