{ pkgs, config, lib, ... }:
{
  home-manager.users.skarmux = {

    # Import all user-specific configurations and
    # minimum package selection
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
        # Media
        celluloid
        plexamp
        gimp
        inkscape
        # Work
        # davinci-resolve
        # blender
        # Streaming
        obs-studio
        twitch-tui
        # ffmpeg_6
        # Util
        mdp
        keepassxc
        obsidian
        # Meta Quest 3 Sideloading
        sidequest
        # Office
        libreoffice
        # Torrent
        deluge
        # Emulators
        # ryujinx
        # dolphin-emu
        cool-retro-term
      ];

      xdg.mimeApps = {
        enable = true; # .config/mimeapps.list
        defaultApplications = {
          "image/jxl" = [ "org.gnome.Loupe.desktop" ];
        };
        associations.added = { };
      };

      persistence."/persist/home/skarmux" = {
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
          ".config/BraveSoftware/Brave-Browser"
          ".config/dconf"
          ".config/discord"
          ".config/keepasxc"
          ".config/libreoffice"
          ".config/nautilus"
          ".config/Proton"
          ".config/protonvpn"
          ".config/protonfixes"
          ".config/Signal"
          ".config/gnome-session"
          ".local/share/Trash"
          ".local/share/zoxide"
          ".local/share/keyrings"
          ".local/share/gvfs-metadata"
          ".local/share/TelegramDesktop"
          ".local/share/Plexamp"
          ".local/state/syncthing"
          ".steam"
        ];
        files = [
          ".config/background"
          ".config/gnome-initial-setup-done"
          # ".config/direnv/???"
        ];
      };
    };

    fonts.fontconfig.enable = true;

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
      llm.enable = true;
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
    ]) ++ (lib.optionals config.programs.adb.enable [ "adbusers" ]);
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../keys/id_yc.pub)
      (builtins.readFile ../../../keys/id_ya.pub)
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

  programs.adb.enable = true; # Required for SideQuest

  sops.secrets = {
    "skarmux-password".neededForUsers = true;
    "yubico/u2f_keys" = {
      owner = config.users.users.skarmux.name;
      inherit (config.users.users.skarmux) group;
      path = "/home/skarmux/.config/Yubico/u2f_keys";
    };
  };
}
