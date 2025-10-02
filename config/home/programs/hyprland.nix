{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    slurp
    hyprpicker
  ];

  wayland.windowManager.hyprland = {

    enable = true;

    settings = {

      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/

      # FIXME: Ghostty is bugged right now. It freezes. Also crashes when
      #        displaying image previews in yazi (Probably due to opacity of
      #        both ghostty and preview)
      # "$terminal" = "ghostty --gtk-single-instance=true";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      "$launcher" = "pkill wofi || wofi --show drun";
      "$browser" = "brave";
      "$screenshot" = "grim -g \"$(slurp)\"";
      "$screenshot_edit" = "wl-paste | swappy -f -";
      # "$dashboard" = "eww open --config ~/.config/eww/dashboard --toggle dashboard";

      #################
      ### AUTOSTART ###
      #################

      exec-once = [
        # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        # "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
        # (pkgs.writeShellScript "keymapp-silent" ''
        #   #!/usr/bin/env bash
        #   # bind = $mod, S, togglespecialworkspace, magic
        #   # bind = $mod, S, movetoworkspace, +0
        #   # bind = $mod, S, togglespecialworkspace, magic
        #   # bind = $mod, S, movetoworkspace, special:magic
        #   # bind = $mod, S, togglespecialworkspace, magic
        #   hyprctl dispatch -- exec keymapp
        #   hyprctl dispatch -- movetoworkspacesilent special
        # '')
      ];

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = [
        "XCURSOR_SIZE,48"
        "HYPRCURSOR_SIZE,48"

        # Workaround for cursor glitches in wlroots
        "WLR_NO_HARDWARE_CURSORS,1"

        # Defines session type
        "XDG_SESSION_TYPE,wayland"

        # TODO (Test) Allow for VRR to work properly
        # https://github.com/hyprwm/Hyprland/issues/4436#issuecomment-1907641839
        "WLR_DRM_NO_ATOMIC,1"

        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
      ];

      ###################
      ### PERMISSIONS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Permissions/

      permissions = {};

      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = lib.mkDefault 20;
        gaps_out = lib.mkDefault 40;
        border_size = 2;

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;
        # extend_border_grab_area = true
        # hover_icon_on_border = true

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = true;

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = lib.mkDefault true;
          size = 12;
          passes = 3;
          # ignore_opacity
          # new_optimizations
          # xray
          # noise
          # contrast
          # brightness
          vibrancy = 0.1696;
          # vibrancy_darkness
          special = true;
          popups = false;
          # popups_ignorealpha
          # input_methods
          # input_methods_ignorealpha
        };

        shadow = {
          enabled = lib.mkDefault true;
          range = 4;
          render_power = 3;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        repeat_rate = 30;
        repeat_delay = 175;

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        accel_profile = "flat";

        touchpad = {
          natural_scroll = lib.mkDefault false;
        };
      };

      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      # NOTE: Should be configured per host
      # device = [ ];

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
      };

      group = {
        auto_group = true;
        insert_after_current = true;

        groupbar = {
          enabled = true;
        };
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      ############
      ### MISC ###
      ############

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 2; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };

      ###################
      ### KEYBINDINGS ###
      ###################

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "SUPER, Q, exec, $terminal"
        "SUPER, W, exec, $browser"
        "SUPER, K, killactive,"
        "SUPER, M, exit,"
        "SUPER, E, exec, $fileManager"
        "SUPER, V, togglefloating,"
        "SUPER, S, exec, $screenshot"
        "SUPER SHIFT, S, exec, $screenshot_edit"
        "CTRL, Space, exec, $launcher"

        # TODO: What do these do?
        "SUPER, P, pseudo, # dwindle"
        "SUPER, J, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # Move window to another position on screen
        "SUPER SHIFT, left, swapwindow, l"
        "SUPER SHIFT, right, swapwindow, r"
        "SUPER SHIFT, up, swapwindow, u"
        "SUPER SHIFT, down, swapwindow, d"

        # Example special workspace (scratchpad)
        # "SUPER, S, togglespecialworkspace, magic"
        # "SUPER SHIFT, S, movetoworkspace, special:magic"
      ]
      ++ (builtins.map(x: "SUPER, ${toString x}, workspace, ${toString x}") [1 2 3 4 5 6 7 8 9 0])
      ++ (builtins.map(x: "SUPER SHIFT, ${toString x}, movetoworkspace, ${toString x}") [1 2 3 4 5 6 7 8 9 0]);

      # passthrough
      # bindn = [ ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        # ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        # ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        # ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        # ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        # ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # Requires playerctl
        # ", XF86AudioNext, exec, playerctl next"
        # ", XF86AudioPause, exec, playerctl play-pause"
        # ", XF86AudioPlay, exec, playerctl play-pause"
        # ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindr = [
        # Toggle dashboard
        # "SUPER, Super_L, exec, $dashboard"
      ];

      bindm = [
        "SUPER, $mouse_left, movewindow"        
        "SUPER, $mouse_middle, killactive"
        "SUPER, $mouse_right, resizewindow"
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # FIXME: Use monitors module
      workspace = [
        # "Smart gaps" / "No gaps when only"
        # uncomment all if you wish to use that.
        # NOTE: Brave browser is clipping out of the visible screen with this.
        # "w[tv1], gapsout:0, gapsin:0"
        # "f[1], gapsout:0, gapsin:0"

        # Don't show borders as long as there is just a single (v)isible window
        # Do not count floating windows. TODO: Floating windows do need a border though
        # to signify that they are focused...
        "w[tv1], border:0"
      ];

      # NOTE: Uses Google's RE2 RexEx engine!
      # https://github.com/google/re2/wiki/Syntax

      windowrule = [
        # Reduce burn-in risk on oled monitor by not showing borders
        # "bordersize 0, floating:0, monitor:${lgcx.port}"
        # "rounding 0, floating:0, monitor:${lgcx.port}"
      
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Fullscreen games that don't overlay
        # TODO: Somehow applied to all windows...
        # "bordersize 0, floating:0, class:^(steam_app_).*$"
        # "rounding 0, floating:0, class:^(steam_app_).*$"
        # "dimaround 1, floating:0, class:^(steam_app_).*$"
        # "monitor ${lgcx.port}, floating:0, class:^(steam_app_).*$"

        # Open application windows on fixed workspaces
        "workspace 2 silent, class:brave-browser"
        "workspace 4 silent, class:firefox"
        "workspace 5 silent, class:steam"
        "workspace 5 silent, class:discord"
        "workspace 5 silent, class:keymapp"

        # TODO: Launch in special workspace
        # - I can define up to 97 named special workspaces!
        # - special:<name> is only supported on movetoworkspace and movetoworkspacesilent
        # Alternative using keybind: https://wiki.hypr.land/Configuring/Uncommon-tips--tricks/#minimize-windows-using-special-workspaces

        # Floating
        "float, class:io.github.kaii_lb.Overskride"
        "float, class:org.pulseaudio.pavucontrol"
        "float, class:org.keepassxc.KeePassXC"
        "float, class:xdg-desktop-portal-gtk"
        "float, class:^(brave)$"
        # FIXME: The lookahead regex `?!` does not apply in hyprland
        "float, class:steam, title:^(?!Steam$).*"
      
        "size 50% 50%, class:io.github.kaii_lb.Overskride"
        "size 50% 50%, class:org.pulseaudio.pavucontrol"
        "size 50% 50%, class:org.keepassxc.KeePassXC"
      ];

      layerrule = [
        # ignorezero: mask blur. Do not blur on 100% transparent pixels
        # "blur, eww-dashboard"
        # "ignorezero, eww-dashboard"
        # "dimaround, eww-dashboard"
        "blur, caelestia-drawers"

        # NOTE: Without ignorezero, the entire screen will be blurred since caelestia
        # is on the (top) layer. lol
        "ignorezero, caelestia-drawers"

        # TODO: I don't like how the blur does not play well with the dropshadow from
        #       the caelestia shell drawers.

        # TODO: The caelestia-shell power menu dims the entire screen and causes blur...

        # "blur, caelestia-border-exclusion"
        # "ignorezero, caelestia-border-exclusion"
      ];

      experimental = {
        # xx_color_management_v4 = true;
      };
    }; # settings

    extraConfig = ''
      bind = CTRL, B, exec, tmux-hyprfocus
    '';

  };
}
