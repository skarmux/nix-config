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
            host = "gitlab.com github.com";
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
      (builtins.readFile ../../../keys/id_yc.pub)
      (builtins.readFile ../../../keys/id_ya.pub)
    ];
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
  #       ".local/share/backgrounds" # [GNOME] This is where gnome stores all user-added backgrounds
  #       ".steam" # <- Games are here!
  #       # TODO: Both are nix-related. The ~/.nix-profile symlink is pointing to a non-existing profile
  #       #       and I think that is because I deleted ~/.local/state/nix once.
  #       ".local/state/nix"
  #       ".local/state/home-manager"
  #       ".local/state/syncthing"
  #     ];
  #     files = [
  #       # Browser
  #       ".config/BraveSoftware/Brave-Browser/Default/Bookmarks"
  #       # FIXME Place into sops... Oh, wait, but it is used BY sops...
  #       #       Need to rethink attack vectors there.
  #       ".config/sops/age/keys.txt"
  #     ];
  #   };
  # };

  yubico = {
    enable = true;
    keys = [
      {
        serial = 24686370;
        owner = "skarmux";
        publicKeyFile = ../../../keys/id_yc.pub;
        privateKeyFile = config.sops.secrets."ssh_yubi_c".path;
      }
      {
        serial = 25390376;
        owner = "skarmux";
        publicKeyFile = ../../../keys/id_ya.pub;
        privateKeyFile = config.sops.secrets."ssh_yubi_a".path;
      }
    ];
  };

  programs.adb.enable = true; # Required for SideQuest

  sops.secrets = {
    "skarmux-password".neededForUsers = true;
    "ssh_yubi_a" = {
      owner = config.users.users.skarmux.name;
      # group = config.users.users.skarmux.group;
    };
    "ssh_yubi_c" = {
      owner = config.users.users.skarmux.name;
      # group = config.users.users.skarmux.group;
    };
    # "yubico/u2f-keys" = {
    #   owner = config.users.users.skarmux.name;
    #   inherit (config.users.users.skarmux) group;
    #   path = "/home/skarmux/.config/Yubico/u2f_keys";
    # };
  };
}
