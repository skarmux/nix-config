{ self, inputs, pkgs, config, lib, ... }:
{
  # Home

  home-manager.users.skarmux = {

    imports = [ ../../../home/skarmux/home.nix ];

    home = {
      packages = [
        # Browser
        pkgs.brave
        # Messenger
        pkgs.discord
        pkgs.element-desktop
        pkgs.signal-desktop
        pkgs.telegram-desktop
        # Media
        pkgs.celluloid
        pkgs.plex-media-player
        pkgs.plexamp
        pkgs.gimp
        # Streaming
        pkgs.obs-studio
        pkgs.twitch-tui
        pkgs.ffmpeg_6
        # Util
        pkgs.keepassxc
        pkgs.obsidian
        # Office
        pkgs.libreoffice
        # AI
        pkgs.llm # command line llm
      ];
    };

    services = {
      yubikey-touch-detector.enable = true;
      syncthing = {
        enable = true;
        # https://docs.syncthing.net/users/syncthing.html
        extraOptions = [
          "--gui-address=https://127.0.0.1:8384"
          "--no-default-folder"
        ];
      };
    };

    programs = {
      direnv.enable = true;
      ghostty.enable = true;
      ssh = {
        enable = true;
        # Required for yubi-agent
        extraConfig = ''
          AddKeysToAgent yes
        '';
        matchBlocks = {
          "yubikey-hosts" = {
            host = "gitlab.com github.com";
            identitiesOnly = true;
            identityFile = [
              "~/.ssh/id_yubikey"
            ];
          };
        };
      };
    };
  };

  # NixOS

  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "i2c" # For zsa voyager
    ] ++ (lib.optionals config.networking.networkmanager.enable [
      "networkmanager"
    ]);
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../home/skarmux/id_yc.pub)
      (builtins.readFile ../../../home/skarmux/id_ya.pub)
    ];
  };

  yubikey = {
    enable = true;
    identifiers = {
      yc = 24686370;
      ya = 25390376;
    };
    lockScreen = false;
  };

  sops.secrets = {
    "skarmux-password".neededForUsers = true;
    "yubico/u2f_keys" = {
      owner = config.users.users.skarmux.name;
      inherit (config.users.users.skarmux) group;
      path = "/home/skarmux/.config/Yubico/u2f_keys";
    };
  };
}
