{ inputs, config, pkgs, lib, ... }:
let
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
in
{
  imports = [
    ./waybar.nix
    ./wofi.nix
    ./qt.nix
    ./gtk.nix
    ./font.nix
    ./dunst.nix
    ./thunar.nix
  ];

  
  xdg.portal = {
    enable = true;
    config.common.default = "*";
  #   extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
  #   configPackages = [ pkgs.inputs.hyprland.hyprland ];
  };

  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;

  home.packages = with pkgs; [ wl-clipboard ];
  
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;

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

      "$MOD" = lib.mkDefault "SUPER";

      exec-once = []
      ++ (lib.optionals config.services.dunst.enable [
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
        # cursor_inactive_timeout = lib.mkDefault 0; # seconds
        # no_cursor_warps = true;
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

      layerrule = (lib.optionals config.programs.waybar.enable) [
        "blur,waybar"
        "ignorezero,waybar"
      ];

      input = {
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
      };

      windowrulev2 = [
        "float,title:^(Confirm to replace files)"
        "float,title:^(File Operation Progress)"
        "float,title:^(Extract archive)"
        "float,title:^(Save File)$"
        # NOTE: Window without rule setting opens above screen size
        "size 50% 80%,class:firefox,title:^(Enter name of file to save to...)$"
      ]
      ++ (lib.optionals config.programs.wofi.enable [
        "noanim,class:(wofi)"
        "stayfocused,class:(wofi)"
        "pin,class:(wofi)"
      ])
      ++ (lib.optionals config.services.opensnitch-ui.enable [
        "float,class:(opensnitch_ui),title:^(OpenSnitch Network Statistics)"
        "float,class:(opensnitch_ui),title:^(OpenSnitch)"
      ])
      ++ (lib.optionals (hasPackage "pavucontrol") [
        "float,class:(pavucontrol)"
      ])
      ++ (lib.optionals (hasPackage "keepassxc") [
        "float,class:(org.keepassxc.KeePassXC)"
      ])
      ++ (lib.optionals (hasPackage "blueman") [
        "float,class:(.blueman-manager-wrapped)"
      ]);

      binde = [
        # Resize window
        "$MOD_CONTROL_L,Left,resizeactive,-20 0"
        "$MOD_CONTROL_L,Right,resizeactive,20 0"
        "$MOD_CONTROL_L,Up,resizeactive,0 -20"
        "$MOD_CONTROL_L,Down,resizeactive,0 20"
      ];

      bind = [
        "$MOD,Q,killactive"
        "$MOD,T,exec,${config.home.sessionVariables.TERMINAL}"
        "$MOD,F,togglefloating"
        "$MOD,V,workspaceopt,allfloat"
        "$MOD,M,exit"

        # (Generic) Switch workspace
        "$MOD,1,workspace,1"
        "$MOD,2,workspace,2"
        "$MOD,3,workspace,3"
        "$MOD,4,workspace,4"
        "$MOD,5,workspace,5"
        "$MOD,6,workspace,6"
        "$MOD,7,workspace,7"
        "$MOD,8,workspace,8"
        "$MOD,9,workspace,9"
        "$MOD,0,workspace,10"

        # (Generic) Move window to workspace
        "$MOD_SHIFT,1,movetoworkspace,1"
        "$MOD_SHIFT,2,movetoworkspace,2"
        "$MOD_SHIFT,3,movetoworkspace,3"
        "$MOD_SHIFT,4,movetoworkspace,4"
        "$MOD_SHIFT,5,movetoworkspace,5"
        "$MOD_SHIFT,6,movetoworkspace,6"
        "$MOD_SHIFT,7,movetoworkspace,7"
        "$MOD_SHIFT,8,movetoworkspace,8"
        "$MOD_SHIFT,9,movetoworkspace,9"
        "$MOD_SHIFT,0,movetoworkspace,10"

        # Relative movement
        "$MOD,Home,workspace,-1"
        "$MOD,End,workspace,+1"
        "$MOD_SHIFT,Home,movetoworkspace,-1"
        "$MOD_SHIFT,End,movetoworkspace,+1"

        # Move focus
        "$MOD,Left,movefocus,l"
        "$MOD,Down,movefocus,d"
        "$MOD,Up,movefocus,u"
        "$MOD,Right,movefocus,r"

        # Swap window
        "$MOD_SHIFT,Left,swapwindow,l"
        "$MOD_SHIFT,Down,swapwindow,d"
        "$MOD_SHIFT,Up,swapwindow,u"
        "$MOD_SHIFT,Right,swapwindow,r"

      ]
      ++ (lib.optionals config.programs.wofi.enable [
        "$MOD,R,exec,pkill wofi || ${pkgs.wofi}/bin/wofi"
      ])
      ++ (lib.optionals config.programs.hyprlock.enable [ 
        "$MOD,H,exec,${pkgs.hyprlock}/bin/hyprlock"
      ])
      ++ (lib.optionals config.programs.wlogout.enable [
        "$MOD,P,exec,pkill wlogout || ${pkgs.wlogout}/bin/wlogout"
      ]);

      bindm = [ "$MOD,mouse:272,movewindow" "$MOD,mouse:273,resizewindow" ];

      misc = {
        disable_hyprland_logo = false;
        disable_splash_rendering = false;
        force_default_wallpaper = 3;
        background_color = "0x1e1e2e";
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

    };
  };

}

