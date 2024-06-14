{ pkgs, config, ... }:
{
  imports = [
    ../skarmux/global 

    ../skarmux/session/hyprland

    ../skarmux/application/keepassxc
    ../skarmux/application/firefox
    ../skarmux/application/nextcloud.nix
  ];

  home.username = "deck";

  gtk.enable = false;
  qt.enable = false;
  programs = {
    waybar.enable = false;
    hyprlock.enable = false;
  };
  services.dunst.enable = false;

  wayland.windowManager.hyprland = {
    # `SUPER` key is reserved on SteamOS
    settings."$MOD" = "Alt_R";
  }; 

  # https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
  home.packages = [
    (pkgs.writeShellScriptBin "Hyprlaunch" /* bash */ ''
      unset LD_PRELOAD
      source /etc/profile.d/nix.sh
      exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${config.wayland.windowManager.hyprland.package}/bin/Hyprland
    '')
  ];

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
