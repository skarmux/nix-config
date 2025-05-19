{ lib, pkgs, config, ... }:
let
  cfg = config.arcade;

  retroarch-gamescope = pkgs.writeShellScriptBin "retroarch-gamescope" ''
    gamescope -r 60 -W 3840 -H 2560 -w 3840 -h 2560 --hdr-enabled -- retroarch
  '';

  retroarchSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=RetroArch
      Comment=An emulation hub
      Exec=${retroarch-gamescope}/bin/retroarch-gamescope
      Type=Application
    '').overrideAttrs
      (_: {
        passthru.providedSessions = [ "steam" ];
      });
in
{
  options.arcade = {
    enable = lib.mkEnableOption "Retro Gaming";
  };

  config = lib.mkIf cfg.enable {

    services.displayManager.sessionPackages = [
      retroarchSessionFile
    ];

    environment.systemPackages = with pkgs; [
      (retroarch.override {
        cores = with libretro; [
          dolphin
          snes9x
          beetle-psx-hw
        ];
      })
      # (pkgs.mkDerivation {
      #   pname = "libretro-common-shaders";
      #   version = "0.1.0";
      #   src = builtins.fetchFromGithub {
      #     url = "https://github.com/libretro/common-shaders.git";
      #     sha265 = "";
      #   };
      #   installPhase = ''
      #     cp -r $out /home/skarmux/.config/retroarch/
      #   '';
      # })
    ];
  
  };
}
