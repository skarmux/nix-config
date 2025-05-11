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
        libjxl
        steam
        # (retroarch.override {
        #   cores = with libretro; [ # decide what emulators you want to include
        #     puae # Amiga 500
        #     scummvm
        #     dosbox
        #   ];
        # })
        # ZSA voyager
        kontroll
        keymapp
      ];

      file = {
        # Login/sudo 'known_hosts'-like config for pam_u2f
        ".config/Yubico/u2f_keys".text = "skarmux:L8qjIWOWGoj0solA3TySPcUw0eOS7ik7nuuleOBE+gX5aMpW6zV1Otbpt43fwwi4kCV+rUMe7Zd19FsLN1h6Gg==,nIB1p7exghHOla/8H/YYE1+slFvcrU1dPOJHylpzr/DwgTji/evnANcwD9CRHJJ1ZkrwDSCRjw4yLn/Uq5rN/A==,es256,+presence:HoxTlnSB0PGZXufQTIev0WrAEmAvuFrIfJHUsIBlIfLNAyXuXXvTfCgVHjYFl/uFzQ5na8lYhS7aI5OtrQHTOg==,74dG2GAw/mveqaGg3C2tKq67shzOi3U4U8nMrCZFXh9ntIEViCzVm8Ejx4gL15t1zJGlUbUAwEQ+aJl9thmXeA==,es256,+presence";
      };
    };

    # xdg.mimeApps = {
    #   enable = true; # .config/mimeapps.list
    #   defaultApplications = {
    #     "image/jxl" = [ "org.gnome.Loupe.desktop" ];
    #     "image/png" = [ "org.gnome.Loupe.desktop" ];
    #     "image/gif" = [ "org.gnome.Loupe.desktop" ];
    #     "image/jpg" = [ "org.gnome.Loupe.desktop" ];
    #     "image/bmp" = [ "org.gnome.Loupe.desktop" ];
    #     "application/pdf" = [ "org.gnome.Evince.desktop" ];
    #   };
    #   associations.added = { };
    # };

    fonts.fontconfig.enable = true;

    services = {
      # Display a desktop notification (with sound)
      # when the key needs to be touched.
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
      ssh = {
        enable = true;
        # Required for yubi-agent
        extraConfig = ''
          AddKeysToAgent yes
        '';
        matchBlocks = {
          "yubikey-hosts" = {
            host = "gitlab.com github.com pewku";
            identitiesOnly = true;
            identityFile = [ "~/.ssh/id_yubikey" ];
          };
        };
      };
      direnv.enable = true;
      ghostty.enable = true;
      llm.enable = true;
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
      # Read files into strings
      (builtins.readFile ../../../keys/id_yc.pub)
      (builtins.readFile ../../../keys/id_ya.pub)
    ];
  };

  # Wine
  environment.systemPackages = with pkgs; [
    # support both 32-bit and 64-bit applications
    wineWowPackages.stable
    # wine-staging (version with experimental features)
    # wineWowPackages.staging
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    vlc
  ];

  # Login/sudo with yubikeys
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    u2f = {
      enable = true;
      settings = {
        cue = false; # set to false since I'm using the yubikey-touch-detector homeModule
        debug = false;
      };
    };
  };

  # environment.persistence."/persist" = {
  #   users.skarmux = {
  #     directories = [
  #       "Desktop"
  #       "Documents"
  #       "Downloads"
  #       "Music"
  #       "Pictures"
  #       "Public"
  #       "Templates"
  #       "Videos"
  #       ".config/Proton"
  #       ".config/Signal"
  #       ".config/discord"
  #       ".config/keepassxc"
  #       ".config/libreoffice"
  #       ".config/nautilus"
  #       # Proton
  #       ".config/protonfixes"
  #       ".config/protonvpn"
  #       ".local/share/Plexamp"
  #       ".local/share/Steam"
  #       ".local/share/TelegramDesktop"
  #       ".local/share/direnv/allow" # NOTE: I'm slowly starting to dislike direnv... ;(
  #       ".local/share/keyrings"
  #       ".local/share/zoxide" # Store last visited directories
  #       ".steam" # <- Games are here!
  #       ".local/state/nix"
  #       ".local/state/home-manager"
  #       ".local/state/syncthing"
  #     ];
  #     files = [
  #       ".config/BraveSoftware/Brave-Browser/Default/Bookmarks"
  #     ];
  #   };
  # };

  yubico.enable = true;
  yubico.keys = [
    {
      serial = 24686370;
      owner = "skarmux";
      publicKeyFile = ../../../keys/id_yc.pub;
      privateKeyFile = config.sops.secrets."yubico/ssh/yc".path;
    }
    {
      serial = 25390376;
      owner = "skarmux";
      publicKeyFile = ../../../keys/id_ya.pub;
      privateKeyFile = config.sops.secrets."yubico/ssh/ya".path;
    }
  ];

  programs.adb.enable = true; # Required for SideQuest

  sops.secrets = {
    "skarmux-password" = {
      neededForUsers = true;
    };
    "yubico/ssh/ya" = {
      mode = "400";
      owner = config.users.users.skarmux.name;
      group = config.users.users.skarmux.group;
    };
    "yubico/ssh/yc" = {
      mode = "400";
      owner = config.users.users.skarmux.name;
      group = config.users.users.skarmux.group;
    };
  };
}
