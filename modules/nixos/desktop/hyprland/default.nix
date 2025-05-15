{ inputs, pkgs, config, lib, ... }:
let
  cfg = config.mods.hyprland;
in
{
  options.mods.hyprland = {
    enable = lib.mkEnableOption "Hyprland Desktop";
  };
  
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment.systemPackages = [ pkgs.nautilus pkgs.wofi ];

    # Screensharing
    xdg.portal = {
      enable = true;
      extraPortals = [
        config.programs.hyprland.portalPackage
      ];
    };


  };
}
