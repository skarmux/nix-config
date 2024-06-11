{
  imports = [
    ./global 
    ./yubikey
    ./session/hyprland 

    ./application/firefox.nix
    ./application/nextcloud.nix
    ./application/kdeconnect.nix
    ./application/imv.nix
    ./application/zathura.nix
    ./application/keepassxc
    ./application/wezterm.nix
    ./application/nextcloud.nix
  ];

  monitors = [
    {
      name = "eDP-1";
      width = 1600;
      height = 900;
      refreshRate = 60;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];

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
        border_size = 2;
        # cursor_inactive_timeout = 5; # seconds
        layout = "dwindle";
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
    battery.bat = "CMB1";
  };
}
