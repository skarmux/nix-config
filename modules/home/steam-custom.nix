{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.steam-custom;

  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      [
        pkgs.xorg.libXcursor
        pkgs.xorg.libXi
        pkgs.xorg.libXinerama
        pkgs.xorg.libXScrnSaver
        pkgs.libpng
        pkgs.libpulseaudio
        pkgs.libvorbis
        pkgs.stdenv.cc.cc.lib
        pkgs.libkrb5
        pkgs.keyutils
        pkgs.gamescope
        pkgs.mangohud
      ];
  };

  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  steam-session =
    pkgs.writeTextDir "share/wayland-sessions/steam-sesson.desktop" # ini
    ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${pkgs.gamescope}/bin/gamescope -W ${toString monitor.width} -H ${
        toString monitor.height
      } -O ${monitor.name} -e -- steam -gamepadui
      Type=Application
    '';
in {
  options.steam-custom = {
    enable = mkEnableOption "Steam with custom packaging.";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.steam-with-pkgs
      pkgs.steam-session
      pkgs.gamescope
      pkgs.mangohud
      pkgs.protontricks
    ];
  };
}
