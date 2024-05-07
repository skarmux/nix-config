{
  imports = [
    ./global 
    ./features/desktop/hyprland 
  ];

  monitors = [{ # Builtin Display
    name = "eDP-1";
    width = 1600;
    height = 900;
    noBar = true;
    refreshRate = 60;
    x = 0;
    workspace = "1";
    primary = true;
  }];

  home.sessionVariables = {
    # Mozilla (firefox,etc.)
    # Better touchscreen and touchpad support as well as smooth scrolling
    MOZ_USE_XINPUT2 = "1";
  };

  wayland.windowManager.hyprland = {
    settings = {
      gestures.workspace_swipe = "on";

      input.touchpad = {
        natural_scroll = "yes";
        disable_while_typing = true;
      };

      master = { no_gaps_when_only = true; };
      dwindle = { no_gaps_when_only = true; };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        cursor_inactive_timeout = 5; # seconds
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
      };
    };

    # Builtin keyboard is either/both of those devices
    extraConfig = ''
      device {
        name = fujitsu-fuj02e3
        kb_layout=de
        numlock_by_default=false
      }
      device {
        name = at-translated-set-2-keyboard
        kb_layout=de
        numlock_by_default=false
      }
    '';
  };

  programs.waybar.settings.primary = {
    modules-right = [ "battery" ];
    battery.bat = "CMB01";
  };
}
