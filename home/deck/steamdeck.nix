{ pkgs, lib, ... }:
{
  imports = [
    ../skarmux/global 

    ../skarmux/session/hyprland

    ../skarmux/application/keepassxc
    ../skarmux/application/firefox.nix
    ../skarmux/application/nextcloud.nix
  ];

  home.username = "deck";

  programs = {
    gtk.enable = false;
    qt.enable = false;
    waybar.enable = false;
    hyprlock.enable = false;
  };

  services.dunst.enable = false;

  wayland.windowManager.hyprland = {
    # `SUPER` key is reserved on SteamOS
    "$MOD" = "Alt_R";
  }; 

  # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
  home.file = {
    ".local/bin/Hyprland" = {
      source = lib.writeShellScriptBin /* bash */ ''
        unset LD_PRELOAD
        source /etc/profile.d/nix.sh
        exec ${pkgs.nixGLIntel}/bin/nixGLIntel ${pkgs.hyprland}/bin/Hyprland
      '';
      executable = true;
    };
  };

  monitors = [
    {
      name = "X11-1";
      width = 1280;
      height = 800;
      refreshRate = 60;
      x = 0;
      vrr = true;
      hdr = false;
      workspace = "1";
      primary = true;
    }
  ];
}
