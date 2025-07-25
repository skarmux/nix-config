{ pkgs, config, lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      vintagestory = prev.vintagestory.overrideAttrs (oldAttrs: rec {
        version = "1.20.11";
        src = pkgs.fetchurl {
          url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
          hash = "sha256-IOreg6j/jLhOK8jm2AgSnYQrql5R6QxsshvPs8OUcQA=";
        };
      });
    })
  ];

  # for languages server qmlls (Quickshell syntax)
  qt.enable = true;

  home-manager.users.skarmux = {

    # Import all user-specific configurations and
    # minimum package selection
    imports = [ ../../../home/skarmux.nix ];

    home = {
      packages = with pkgs; [
        prismlauncher
        vscode
        gparted
        btop
        brave # FIXME Always launch with `--ozone-platform=wayland`
        discord-ptb
        element-desktop
        fractal
        signal-desktop
        telegram-desktop
        imv # image viewer
        libjxl # jpeg xl
        celluloid # video player
        plexamp # music streaming
        gimp # raster graphics
        inkscape # vector graphics
        firefox
        # davinci-resolve
        # blender
        obs-studio # screen recording & streaming
        twitch-tui # twitch chat
        mdp # markdown presentation tool
        keepassxc
        obsidian
        sidequest # quest 3 sideloading
        libreoffice # office
        deluge # torrenting
        # ryujinx
        # dolphin-emu
        cool-retro-term
        # ZSA voyager
        kontroll
        keymapp
        evince
        vintagestory
        insomnia

        # hackthebox
        inetutils # ftp, etc...
        nmap # port scanning util `-sV` for version scan
        samba # access smb network shares
        redis # in-memory database
        gobuster # check web urls with wordlists
        mariadb-client
      ];

      file = {
        # Login/sudo 'known_hosts'-like config for pam_u2f
        ".config/Yubico/u2f_keys".text = lib.concatStringsSep ":" [
          "skarmux"
          (lib.concatStringsSep "," [
            "L8qjIWOWGoj0solA3TySPcUw0eOS7ik7nuuleOBE+gX5aMpW6zV1Otbpt43fwwi4kCV+rUMe7Zd19FsLN1h6Gg=="
            "nIB1p7exghHOla/8H/YYE1+slFvcrU1dPOJHylpzr/DwgTji/evnANcwD9CRHJJ1ZkrwDSCRjw4yLn/Uq5rN/A=="
            "es256"
            "+presence"
          ])
          (lib.concatStringsSep "," [
            "HoxTlnSB0PGZXufQTIev0WrAEmAvuFrIfJHUsIBlIfLNAyXuXXvTfCgVHjYFl/uFzQ5na8lYhS7aI5OtrQHTOg=="
            "74dG2GAw/mveqaGg3C2tKq67shzOi3U4U8nMrCZFXh9ntIEViCzVm8Ejx4gL15t1zJGlUbUAwEQ+aJl9thmXeA=="
            "es256"
            "+presence"
          ])
        ];
      };

    };

    wayland.windowManager.hyprland.enable = true;

    # Dark Mode for GNOME and GNOME apps
    dconf = {
      enable = true;
      # NOTE: Disabled in favor of stylix
      # settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    xdg.mimeApps = {
      enable = true; # .config/mimeapps.list
      # defaultApplications = {
      #   "image/jxl" = [ "org.gnome.Loupe.desktop" ];
      #   "image/png" = [ "org.gnome.Loupe.desktop" ];
      #   "image/gif" = [ "org.gnome.Loupe.desktop" ];
      #   "image/jpg" = [ "org.gnome.Loupe.desktop" ];
      #   "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      #   "application/pdf" = [ "org.gnome.Evince.desktop" ];
      # };
      # associations.added = { };
    };

    fonts.fontconfig.enable = true;

    services = {
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
      alacritty.enable = true;
      direnv.enable = true;
      ghostty.enable = true;
      llm.enable = true;
      wofi.enable = true;
      nushell.enable = true;
    };
  };

  # NixOS

  users.users.skarmux = {
    isNormalUser = true;
    # shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "i2c" # control connected devices
      "gamemode"
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

  # Login/sudo with yubikeys
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    u2f = {
      enable = true;
      settings.cue = true;
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
