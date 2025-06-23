{ inputs, pkgs, config, ... }:
{
  imports = [ ./nautilus.nix ];

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
      eww
    ] ++ [
    /*
      BenQ 3:2
      3840x2560@59.98Hz
      3840x2560@49.98Hz
      BenQ 16:9
      3840x2160@59.94Hz
      3840x2160@50.00Hz
      3840x2160@29.97Hz
      3840x2160@25.00Hz
      3840x2160@23.98Hz
      BenQ 4:3
      3240x2160@59.99Hz
    */
      (pkgs.writeShellApplication {
        name = "monitor-movie";
        runtimeInputs = [ config.programs.hyprland.package ];
        text = ''
          hyprctl keyword monitor "desc:BNQ BenQ RD280UA HAR0021601Q,3840x2160@23.98,0x0,1"
        '';
      })
      (pkgs.writeShellApplication {
        name = "monitor-std";
        runtimeInputs = [ config.programs.hyprland.package ];
        text = ''
          hyprctl keyword monitor "desc:BNQ BenQ RD280UA HAR0021601Q,3840x2560@59.98,0x0,1,bitdepth,10"
        '';
      })
      (pkgs.writeShellApplication {
        name = "monitor-pal";
        runtimeInputs = [ config.programs.hyprland.package ];
        text = ''
          hyprctl keyword monitor "desc:BNQ BenQ RD280UA HAR0021601Q,3840x2560@49.98,0x0,1,bitdepth,10"
        '';
      })
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
      # HYPRCURSOR_THEME = "phinger-cursors-dark-hyprcursor";
      HYPRCURSOR_SIZE = "48";
    };
  };
}
