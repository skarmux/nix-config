{ pkgs, config, lib, ... }:
{
  imports = [
    ./global 
    ./yubikey
    ./firefox
    # ./hyprland
    ./kdeconnect.nix
    ./imv.nix
    ./zathura.nix
    ./keepassxc
    ./plex.nix
    ./ticker.nix
    ./syncthing.nix
    (import ./wezterm.nix { inherit config lib; default = true; })
    (import ./alacritty.nix { inherit config lib; default = false; })
  ];

  programs.khal.enable = true;
  programs.vdirsyncer.enable = true;

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
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1600;
      workspace = "2";
      primary = false;
    }
    {
      name = "HDMI-A-2";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1600;
      workspace = "2";
      primary = false;
    }
    {
      name = "HDMI-A-3";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1600;
      workspace = "2";
      primary = false;
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
