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

    environment.systemPackages = [
      pkgs.gnomeExtensions.switcher        # App Launcher/Switcher
      pkgs.gnomeExtensions.tactile         # Window Tiling
      pkgs.gnomeExtensions.just-perfection # Tweak Gnome Shell
      pkgs.gnomeExtensions.transparent-top-bar
    ];

    # Part of App Indicator
    services.udev.packages = [
      pkgs.gnome-settings-daemon
    ];

    # Trim GNOME default software
    environment.gnome.excludePackages = ([
      pkgs.atomix   # puzzle game
      pkgs.cheese   # webcam tool
      pkgs.epiphany # web browser
      # pkgs.evince # document viewer
      pkgs.geary    # email reader
      pkgs.gedit    # text editor
      # pkgs.gnome-characters
      pkgs.gnome-music
      # pkgs.gnome-photos
      # pkgs.gnome-terminal
      pkgs.gnome-tour
      pkgs.hitori   # sudoku game
      pkgs.iagno    # go game
      pkgs.tali     # poker game
      pkgs.totem    # video player (broken on wayland)
    ]);
  };
}
