{ config, pkgs, ... }:
let
  # replacing `-tenfoot` with `-steamos3 -gamepadui` to make `Exit to Desktop` quit the session.
  # yes, it works. :)
  # steam-gamescope = let
    # exports = builtins.attrValues (
    #   builtins.mapAttrs (n: v: "export ${n}=${v}") config.programs.steam.gamescopeSession.env
    # );
    # Write this into the shellScriptBin
    # ${builtins.concatStringsSep "\n" exports}
  # in
  # pkgs.writeShellScriptBin "steam-gamescope" ''
  #   export MANGOHUD_CONFIG=fps,frametime,fsr,hdr,gamemode,wine,hud_compact,frame_timing,cpu_stats,gpu_stats
  #   LD_PRELOAD="" gamescope --steam --hdr-enabled --mangoapp -- steam -steamos3 -gamepadui
  # '';

  # gamescopeSessionFile =
  #   (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
  #     [Desktop Entry]
  #     Name=Steam Custom
  #     Comment=A digital distribution platform
  #     Exec=${steam-gamescope}/bin/steam-gamescope
  #     Type=Application
  #   '').overrideAttrs(_: {
  #     passthru.providedSessions = [ "steam" ];
  #   });
in
{
  # services = {
  #   displayManager = {
  #     sessionPackages = [ gamescopeSessionFile ];
  #   };
  # };
  
  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [ "--backend drm" "--expose-wayland" "--mangoapp" "--hdr-enabled" ];
        env = {
          MANGOHUD = "1";
          MANGOHUD_CONFIG = "fps,frametime,fsr,hdr,gamemode,wine,hud_compact,frame_timing,cpu_stats,gpu_stats";
          LD_PRELOAD = "";
        };
      };
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = { };
      };
      # extraPackages = with pkgs; [
      #   mangohud
      # ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      # extest.enable = true;
    };
    gamescope.capSysNice = false; # FIXME Can't set this to `true`. Gamescope crashes on startup.
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    # Use `Switch to Desktop` option to close the gamescope session
    # (pkgs.writeShellScriptBin "steamos-session-select" "steam -shutdown")
  ];

  home-manager.users.skarmux = {
    home.file = {
      # Ensure that more than one core is used for vulkan shader processing
      ".steam/steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads 8
      '';
    };
  };
}
