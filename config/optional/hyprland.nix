{ inputs, config, pkgs, ... }:
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
      # XDG_BACKEND = "wayland";
      # XDG_CURRENT_DESKTOP = "Hyprland";
      # XDG_SESSION_TYPE = "wayland";
      # XDG_SESSION_DESKTOP = "Hyprland";

      # GDK_BACKEND = "wayland,x11,*";

      # QT_QPA_PLATFORM = "wayland;xcb";

      # _JAVA_AWT_WM_NONREPARENTING = "1";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # LIBSEAT_BACKEND = "logind";
    };
  };

  ###############
  ### SHELL ###
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
    # extraPortals = with pkgs; [
    #   xdg-desktop-portal-gtk
    # ];
  };

  home-manager.users.skarmux.wayland.windowManager.hyprland.settings = {
  
      # TODO: Monitors can be enabled after the fact with hyprland.conf adjustments,
      #       for example: `hyprctl keyword monitor HDMI-A-1,3840x2160@120,auto-right,1`
      #       It is to cumbersome to type the entire monitor modeline, so store that in
      #       a variable in hyprland.conf or make executable scripts (that might be placed)
      #       in a dashboard.
      monitor = builtins.attrValues (builtins.mapAttrs (monitorName: attrs: 
        if attrs.enabled then
          "${attrs.port}, ${toString attrs.width}x${toString attrs.height}@${toString attrs.refresh}, ${
          if attrs.primary then "0x0" else "auto-right"}, 1 ${
          if attrs.vrr then ", vrr, 3" else ""} # ${monitorName}"
        else
          "${attrs.port}, disable # ${monitorName}"
      ) config.monitors);
  };

}
