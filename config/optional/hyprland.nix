{ inputs, pkgs, config, lib, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment = {
    sessionVariables = {
      XDG_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";

      _JAVA_AWT_WM_NONREPARENTING = "1";

      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      LIBSEAT_BACKEND = "logind";
    };
  };

  ###############
  ### TASKBAR ###
  ###############
  
  caelestia-shell = {
    enable = true;
  };

  ###################
  ### SCREENSHARE ###
  ###################
  
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # config = {
    #   common.default = ["gtk"];
      # hyprland = {
      #   default = ["hyprland" "gtk"];
      # };
    # };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # TODO: Store primary monitor in `$mon_primary` variable maybe?
  home-manager.users.skarmux = {
    wayland.windowManager.hyprland = {
      package = null;
      portalPackage = null;
      settings = let
        primaryMonitor = config.monitors.${
          builtins.head (
            lib.filter (name:
              config.monitors.${name}.primary
              ) (builtins.attrNames config.monitors)
          )};
      in {
        ################
        ### MONITORS ###
        ################

        # I can live with `auto-right` as I'm a single monitor user and
        # have only one configuration with my TV where I'll have `auto-right`.
        monitor = let
          scale = "1"; # NOTE: I think this is a multiplier to the intrinsic scale provided by EDID
        in builtins.attrValues (builtins.mapAttrs (name: m: 
          if m.enabled then
            "${m.port}, ${toString m.width}x${toString m.height}@${toString m.refresh}, ${
            if m.primary then "0x0" else "auto-right"}, ${scale}
            ${if m.vrr then ", vrr, 3" else ""} # ${name}"
          else
            # TODO: Monitors can be enabled after the fact with hyprland.conf adjustments,
            #       for example: `hyprctl keyword monitor HDMI-A-1,3840x2160@120,auto-right,1`
            #       It is to cumbersome to type the entire monitor modeline, so store that in
            #       a variable in hyprland.conf or make executable scripts (that might be placed)
            #       in a dashboard.
            "${m.port}, disable # ${name}"
        ) config.monitors);

        workspace = builtins.map(workspace:
            "${toString workspace}, monitor:${primaryMonitor.port}"
          ) [1 2 3 4 5 6 7 8 9 0];
      };
    };
  };
}
