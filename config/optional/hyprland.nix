{ inputs, pkgs, ... }:
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

}
