{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
        "hyprpaper"
    ];
  };
}