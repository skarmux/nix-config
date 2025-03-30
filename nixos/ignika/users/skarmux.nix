{ self, pkgs, config, lib, ... }:
let
  hm = config.home-manager.users.skarmux;
in
{
  home-manager.users.skarmux = {

    imports = [ ../../../home/skarmux/home.nix ];

    home = {
      packages = with pkgs; [
        # Browser
        brave
        # Messenger
        discord
        element-desktop
        signal-desktop
        telegram-desktop
        # Games
        steam
        # Media
        celluloid
        plex-media-player
        plexamp
        # Streaming
        obs-studio
        twitch-tui
        ffmpeg_6
        # Util
        keepassxc
        ticker
        # Office
        libreoffice
        # AI
        llm # command line llm
      ];
    };

    services.yubikey-touch-detector.enable = true;

    sops.secrets."ticker" = {
      path = "/home/skarmux/.config/.ticker.yaml";
    };
  };

  yubikey = {
    identifiers = {
      yc = 24686370;
      ya = 25390376;
    };
    gpg = true;
    lockScreen = true;
    smartcard = true;
    pam = true;
    u2f = true;
    ssh = true;
  };

  users.users.skarmux = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "i2c"
    ] ++ (lib.optionals config.networking.networkmanager.enable [
      "networkmanager"
    ]);
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    openssh.authorizedKeys.keyFiles = [
      hm.home.file.".ssh/id_ecdsa_sk.pub".path
      hm.home.file.".ssh/id_ed25519.pub".path
    ];
  };
}
