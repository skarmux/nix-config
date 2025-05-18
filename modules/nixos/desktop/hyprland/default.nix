{ inputs, pkgs, config, lib, ... }:
let
  cfg = config.mods.hyprland;
in
{
  imports = [
    ./nautilus.nix
  ];

  options.mods.hyprland = {
    enable = lib.mkEnableOption "Hyprland Desktop";
  };
  
  config = lib.mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true; # recommended for most users
        xwayland.enable = true; # Xwayland can be disabled.
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };
    };

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment = {
      systemPackages = with pkgs; [
        wofi # application launcher
        dunst # notification daemon
        wl-clipboard # wanna use `wl-copy` from terminal
        pavucontrol # control audio devices
        # Screenshot
        grim
        slurp
        # Screensharing
        pipewire
        wireplumber
      ];
    };

    # Screensharing
    xdg.portal = {
      enable = true;
      extraPortals = [ config.programs.hyprland.portalPackage ];
    };

    home-manager.users.skarmux = {
      imports = [
        inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
      ];
      programs.hyprcursor-phinger.enable = true;
      home.sessionVariables = {
        HYPRCURSOR_THEME = "phinger-cursors-dark-hyprcursor";
        HYPRCURSOR_SIZE = "24";
      };
    };
  };
}
