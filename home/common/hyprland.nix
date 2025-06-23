{ ... }:
{
   imports = [
     ./dunst.nix
     ./wofi.nix
   ];
   wayland.windowManager.hyprland = {
     settings = {
       ################
       ### MONITORS ###
       ################

       # See https://wiki.hyprland.org/Configuring/Monitors/

       monitor = [
         "desc:BNQ BenQ RD280UA HAR0021601Q,preferred,0x0,1,bitdepth,10"
         # "desc:LG Electronics LG TV SSCR2 0x01010101,3840x2160@119.879997,3840x0,1,bitdepth,10,vrr,1"
         "desc:LG Electronics LG TV SSCR2 0x01010101,disable"
       ];

       ###################
       ### MY PROGRAMS ###
       ###################

       # See https://wiki.hyprland.org/Configuring/Keywords/

       "$terminal" = "ghostty --gtk-single-instance=true";
       "$fileManager" = "nautilus";
       "$menu" = "wofi --show drun";
       "$browser" = "brave";

       #################
       ### AUTOSTART ###
       #################
       exec-once = [
         "eww daemon"
         "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
       ];

       #############################
       ### ENVIRONMENT VARIABLES ###
       #############################

       # See https://wiki.hyprland.org/Configuring/Environment-variables/
       # env = {
       #   XCURSOR_SIZE = 48;
       #   HYPRCURSOR_SIZE = 48;
       # };

       ###################
       ### PERMISSIONS ###
       ###################

       # See https://wiki.hyprland.org/Configuring/Permissions/

       # permissions = {};

       #####################
       ### LOOK AND FEEL ###
       #####################

       # Refer to https://wiki.hyprland.org/Configuring/Variables/

       # https://wiki.hyprland.org/Configuring/Variables/#general
       general = {
         gaps_in = 5;
         gaps_out = 20;
         border_size = 2;
         # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
         # "col.active_border" = lib.mkForce "rgba(33ccffee) rgba(00ff99ee) 45deg";
         # "col.inactive_border" = lib.mkForce "rgba(595959aa)";

         # Set to true enable resizing windows by clicking and dragging on borders and gaps
         resize_on_border = false;
         # extend_border_grab_area = true
         # hover_icon_on_border = true

         # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
         allow_tearing = false;

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
             enabled = true;
             size = 12;
             passes = 3;

             vibrancy = 0.1696;

             special = true;
             popups = false;
         };

         shadow = {
             enabled = true;
             range = 4;
             render_power = 3;
             # color = lib.mkForce "rgba(1a1a1aee)";
         };
       };

       # https://wiki.hyprland.org/Configuring/Variables/#animations
       animations = {
         enabled = "yes";

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

       # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
       # "Smart gaps" / "No gaps when only"
       # uncomment all if you wish to use that.
       workspace = [
         "w[tv1], gapsout:0, gapsin:0"
         "f[1], gapsout:0, gapsin:0"
         "1, m[desc:BNQ BenQ RD280UA HAR0021601Q]"
         "5, m[desc:LG Electronics LG TV SSCR2 0x01010101]"
       ];

       # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
       dwindle = {
           pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
           preserve_split = true; # You probably want this
       };

       # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
       master = {
           new_status = "master";
       };

       # https://wiki.hyprland.org/Configuring/Variables/#misc
       misc = {
           force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
           disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
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
               natural_scroll = false;
           };
       };

       # https://wiki.hyprland.org/Configuring/Variables/#gestures
       gestures = {
           workspace_swipe = false;
       };

       # Example per-device config
       # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
       device = [
         {
             name = "sony-interactive-entertainment-dualsense-wireless-controller-touchpad";
             # The touchpad would add unwanted mouse inputs through hyprland when running games
             # using the dualsense button mappings.
             enabled = false;
         }
         {
             name = "zsa-technology-labs-voyager";
             kb_layout = "us";
             kb_variant = "altgr-intl";
         }
       ];

       ###################
       ### KEYBINDINGS ###
       ###################

       # See https://wiki.hyprland.org/Configuring/Keywords/
       "$mainMod" = "SUPER";

       # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
       bind = [
         "$mainMod, Q, exec, $terminal"
         "$mainMod, W, exec, $browser"
         "$mainMod, K, killactive,"
         "$mainMod, M, exit,"
         "$mainMod, E, exec, $fileManager"
         "$mainMod, V, togglefloating,"
         "Ctrl, Space, exec, $menu # NOTE: For muscle memory"
         "$mainMod, P, pseudo, # dwindle"
         "$mainMod, J, togglesplit, # dwindle"

         # Move focus with mainMod + arrow keys
         "$mainMod, left, movefocus, l"
         "$mainMod, right, movefocus, r"
         "$mainMod, up, movefocus, u"
         "$mainMod, down, movefocus, d"

         # Switch workspaces with mainMod + [0-9]
         "$mainMod, 1, workspace, 1"
         "$mainMod, 2, workspace, 2"
         "$mainMod, 3, workspace, 3"
         "$mainMod, 4, workspace, 4"
         "$mainMod, 5, workspace, 5"

         # Move active window to a workspace with mainMod + SHIFT + [0-9]
         "$mainMod SHIFT, 1, movetoworkspace, 1"
         "$mainMod SHIFT, 2, movetoworkspace, 2"
         "$mainMod SHIFT, 3, movetoworkspace, 3"
         "$mainMod SHIFT, 4, movetoworkspace, 4"
         "$mainMod SHIFT, 5, movetoworkspace, 5"

         # Example special workspace (scratchpad)
         "$mainMod, S, togglespecialworkspace, magic"
         "$mainMod SHIFT, S, movetoworkspace, special:magic"

         # Scroll through existing workspaces with mouse
         ", mouse_left, workspace, e-1"
         ", mouse_right, workspace, e+1"
       ];

       bindm = [
         # Move/resize windows with mainMod + LMB/RMB and dragging
         "$mainMod, mouse:272, movewindow"
         "$mainMod, mouse:273, resizewindow"
       ];

       bindel = [
         # Laptop multimedia keys for volume and LCD brightness
         ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
         ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
         ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
         ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
         ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
         ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
       ];

       bindl = [
         # Requires playerctl
         ", XF86AudioNext, exec, playerctl next"
         ", XF86AudioPause, exec, playerctl play-pause"
         ", XF86AudioPlay, exec, playerctl play-pause"
         ", XF86AudioPrev, exec, playerctl previous"
       ];

       bindr = [
         # Toggle dashboard
         "SUPER, Super_L, exec, eww open --config ~/.config/eww/dashboard --toggle dashboard"
       ];

       
       ##############################
       ### WINDOWS AND WORKSPACES ###
       ##############################

       # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
       # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

       # Example windowrule
       # windowrule = float,class:^(kitty)$,title:^(kitty)$

       windowrule = [
         "bordersize 0, floating:0, onworkspace:w[tv1]"
         "rounding 0, floating:0, onworkspace:w[tv1]"
         "bordersize 0, floating:0, onworkspace:f[1]"
         "rounding 0, floating:0, onworkspace:f[1]"
         # Ignore maximize requests from apps. You'll probably like this.
         "suppressevent maximize, class:.*"
         # Fix some dragging issues with XWayland
         "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
         #
         "float, class:org.pulseaudio.pavucontrol"
         "size 50% 50%, class:org.pulseaudio.pavucontrol"
         "float, class:org.keepassxc.KeePassXC"
         "size 50% 50%, class:org.keepassxc.KeePassXC"
         "float, class:xdg-desktop-portal-gtk"
         "float, class:io.github.kaii_lb.Overskride"
       ];

       layerrule = [
         # ignorezero: mask blur. Do not blur on 100% transparent pixels
         "blur, eww-dashboard"
         "ignorezero, eww-dashboard"
         "dimaround, eww-dashboard"

         "blur, wofi"
         "ignorezero, wofi"
         "dimaround, wofi"
       ];
     }; # settings
   }; # hyprland
}
