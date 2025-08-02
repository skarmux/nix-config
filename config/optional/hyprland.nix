{ inputs, pkgs, config, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    XDG_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    LIBSEAT_BACKEND = "logind";
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  ###################
  ### SCREENSHARE ###
  ###################
  
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        config.programs.hyprland.portalPackage
      ];
    };
  };

  ################
  ### MONITORS ###
  ################

  home-manager.users.skarmux = {
    wayland.windowManager.hyprland.settings = {
      # I can live with `auto-right` as I'm a single monitor user and
      # have only one configuration with my TV where I'll have `auto-right`.
      monitors = let
        scale = "1";
      in builtins.mapAttrs (name: m: 
        "${m.port}, ${toString m.width}x${toString m.height}@${toString m.refresh}, ${
        if m.primary then "0x0" else "auto-right"}, ${scale}${
        if m.vrr then ", vrr, 3" else ""} # ${name}"
      ) config.monitors;
    };
  };
}
