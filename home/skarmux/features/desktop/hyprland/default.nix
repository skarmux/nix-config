{ config, pkgs, lib, ... }:
{
  imports = [
    ../common
    ../common/wayland/waybar.nix
    ../common/wayland/hyprlock.nix
    ../common/wayland/wofi.nix
  ];

  # xdg.portal = {
  #   extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
  #   configPackages = [ pkgs.inputs.hyprland.hyprland ];
  # };

  home.packages = with pkgs; [ wl-clipboard ];

  wayland.windowManager.hyprland = {
    enable = true;
    catppuccin.enable = true;

    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    extraConfig = ''
      device {
        name = logitech-mx-keys
        kb_layout=us
        kb_variant=altgr-intl
        kb_options=compose:menu,level3:ralt_switch
      }
      device {
        name = zsa-technology-labs-voyager-keyboard
        kb_layout=us
        kb_variant=altgr-intl
      }
    '';

    settings = {

      exec-once = [
        # make sure that xdg-desktop-portal-hyprland gets
        # required variables (for screenshare) on startup
        # ...also fixes apps taking ~20s to open
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ]
      ++ (lib.optionals config.programs.waybar.enable [
        "${pkgs.waybar}/bin/waybar"
      ])
      ++ (lib.optionals config.services.dunst.enable [
        # launch dunst service
        "systemctl start --user dunst.service"
      ])
      ++ (lib.optionals config.gtk.enable [
        "hyprctl setcursor ${config.gtk.cursorTheme.name} ${
          toString config.gtk.cursorTheme.size
        }"
      ]);

      general = {
        gaps_in = lib.mkDefault 10;
        gaps_out = lib.mkDefault 20;
        border_size = lib.mkDefault 3;
        "col.active_border" = "$mauve";
        "col.inactive_border" = "$mantle";
        cursor_inactive_timeout = lib.mkDefault 0; # seconds
        no_cursor_warps = true;
        resize_on_border = true;
        extend_border_grab_area = true;
        layout = lib.mkDefault "master";
        hover_icon_on_border = true;
      };

      decoration = {
        rounding = lib.mkDefault 6;
        # inactive_opacity = 0.9;
        # drop_shadow = true;
        # shadow_range = 32;
        # shadow_render_power = 3;
        # "col.shadow" = "0x55000000";
        # "col.shadow_inactive" = "0x55000000";
        blur = {
          enabled = false;
          # size = 8;
          # passes = 1;
          # new_optimizations = true;
          # ignore_opacity = true;
          # xray = false;
          # noise = 0.1;
        };
      };

      layerrule = [ "blur,waybar" "ignorezero,waybar" ];

      misc = { vrr = 1; };

      input = {
        # 0 - Cursor movement will not change focus.
        # 1 - Cursor movement will always change focus to the window under the cursor.
        # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        follow_mouse = 2;
        repeat_delay = 250;
        numlock_by_default = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        orientation = "center";
        new_is_master = false;
      };

      windowrulev2 = [
        "float,title:^(Confirm to replace files)"
        "float,title:^(File Operation Progress)"
        "float,title:^(Extract archive)"
        "float,title:^(Save File)$"
        "float,class:(.blueman-manager-wrapped)"
        "float,class:(pavucontrol)"
        "float,class:(org.keepassxc.KeePassXC)"
      ] ++ (lib.optionals config.programs.wofi.enable [
        "noanim,class:(wofi)"
        "stayfocused,class:(wofi)"
        "pin,class:(wofi)"
      ]) ++ (lib.optionals config.services.opensnitch-ui.enable [
        "float,class:(opensnitch_ui),title:^(OpenSnitch Network Statistics)"
        "float,class:(opensnitch_ui),title:^(OpenSnitch)"
      ]);

      bindr = (lib.optionals config.programs.wofi.enable [
        "SUPER,SUPER_L,exec,pkill wofi || ${pkgs.wofi}/bin/wofi"
      ]);

      binde = [
        # Resize window
        "SUPER_CONTROL_L,Left,resizeactive,-20 0"
        "SUPER_CONTROL_L,Right,resizeactive,20 0"
        "SUPER_CONTROL_L,Up,resizeactive,0 -20"
        "SUPER_CONTROL_L,Down,resizeactive,0 20"
      ];

      bind = [
        "SUPER,Q,killactive"
        "SUPER,T,exec,${config.home.sessionVariables.TERMINAL}"
        "SUPER,F,togglefloating"
        "SUPER,P,fakefullscreen"
        "SUPER,V,workspaceopt,allfloat"

        # (Generic) Switch workspace
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        "SUPER,9,workspace,9"
        "SUPER,0,workspace,10"

        # (Generic) Move window to workspace
        "SUPER_SHIFT,1,movetoworkspace,1"
        "SUPER_SHIFT,2,movetoworkspace,2"
        "SUPER_SHIFT,3,movetoworkspace,3"
        "SUPER_SHIFT,4,movetoworkspace,4"
        "SUPER_SHIFT,5,movetoworkspace,5"
        "SUPER_SHIFT,6,movetoworkspace,6"
        "SUPER_SHIFT,7,movetoworkspace,7"
        "SUPER_SHIFT,8,movetoworkspace,8"
        "SUPER_SHIFT,9,movetoworkspace,9"
        "SUPER_SHIFT,0,movetoworkspace,10"

        # Relative movement
        "SUPER,Home,workspace,-1"
        "SUPER,End,workspace,+1"
        "SUPER_SHIFT,Home,movetoworkspace,-1"
        "SUPER_SHIFT,End,movetoworkspace,+1"

        # Move focus
        "SUPER,Left,movefocus,l"
        "SUPER,Down,movefocus,d"
        "SUPER,Up,movefocus,u"
        "SUPER,Right,movefocus,r"

        # Swap window
        "SUPER_SHIFT,Left,swapwindow,l"
        "SUPER_SHIFT,Down,swapwindow,d"
        "SUPER_SHIFT,Up,swapwindow,u"
        "SUPER_SHIFT,Right,swapwindow,r"

      ] ++ (lib.optionals config.programs.hyprlock.enable
        [ "SUPER,H,exec,${pkgs.hyprlock}/bin/hyprlock" ])
        ++ (lib.optionals config.programs.wlogout.enable
        [ "SUPER, P, exec, pkill wlogout || ${pkgs.wlogout}/bin/wlogout" ]);

      bindm = [ "SUPER,mouse:272,movewindow" "SUPER,mouse:273,resizewindow" ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        # disable_autoreload = true;
        # background_color = "0x${palette.base00}";
      };

      xwayland = {
        use_nearest_neighbor = true;
        force_zero_scaling = true;
      };

      monitor = builtins.concatMap (m:
        let
          resolution = "${toString m.width}x${toString m.height}@${
              toString m.refreshRate
            }";
          position = "${toString m.x}x${toString m.y}";
          vrr = if m.vrr then ",vrr,1" else "";
          hdr = if m.hdr then ",bitdepth,10" else "";
          top = "${toString m.workspace_padding.top}";
          bottom = "${toString m.workspace_padding.bottom}";
          left = "${toString m.workspace_padding.left}";
          right = "${toString m.workspace_padding.right}";
        in [
          "${m.name},${
            if m.enabled then
              "${resolution},${position},1${vrr}${hdr}"
            else
              "disable"
          }"
          "${m.name},addreserved,${top},${bottom},${left},${right}"
        ]) (config.monitors);

      debug = {
        disable_logs = false;
      };

    };
  };

}

