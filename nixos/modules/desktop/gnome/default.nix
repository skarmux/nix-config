{ pkgs, config, lib, autoLogin ? false, ... }:
let
  cfg = config.mods.gnome;
in
{
  options.mods.gnome = {
    enable = lib.mkEnableOption "Gnome Desktop";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Fix Auto Login
    systemd.services = lib.mkIf config.services.displayManager.autoLogin.enable {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator    # Systray Icons
      gnomeExtensions.space-bar       # Workspace Indicator
      gnomeExtensions.switcher        # App Launcher/Switcher
      gnomeExtensions.tactile         # Window Tiling
      gnomeExtensions.just-perfection # Tweak Gnome Shell
    ];

    # Part of App Indicator
    services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    # Trim GNOME default software
    environment.gnome.excludePackages = (with pkgs; [
      atomix   # puzzle game
      cheese   # webcam tool
      epiphany # web browser
      # evince # document viewer
      geary    # email reader
      gedit    # text editor
      # gnome-characters
      # gnome-music
      # gnome-photos
      # gnome-terminal
      gnome-tour
      hitori   # sudoku game
      iagno    # go game
      tali     # poker game
      totem    # video player (broken on wayland)
    ]);
  };
}
