{ pkgs, lib, ... }:
{
    imports = [
        ./modules/stylix.nix
        ./programs/alacritty.nix
        ./programs/hyprland.nix
        # ./programs/dunst.nix # NOTE: Notifications handled by caelestia-shell
        ./programs/wofi.nix
        ./programs/dolphin.nix
        ./services/hyprpaper.nix
        ./services/syncthing.nix
    ];

    nixpkgs.config = {
      allowUnfree = lib.mkForce false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "discord-ptb"
        "vscode"
        "plexamp"
        "obsidian"
        "grayjay"
        "steam" # dependency of lutris
        "steam-unwrapped"
        "makemkv"
        "davinci-resolve"
      ];
    };

    home = {
      packages = with pkgs; [
        insomnia # api checking
        vscode # graphical editor
        
        # browser
        firefox
        brave

        # messenger
        discord-ptb
        element-desktop
        signal-desktop
        telegram-desktop

        # multimedia
        evince # pdf viewer

        # images
        imv # tiled image viewer
        swayimg
        # kdePackages.gwenview
        # qview
        # koko
        oculante
        libjxl # jpeg xl

        celluloid # video player
        plexamp # music streaming
        gimp # raster graphics
        darktable
        inkscape # vector graphics
        grayjay
        vlc

        keepassxc # password management
        obsidian # notetaking
        libreoffice # office

        deluge

        wl-clipboard

        # warcraft 3
        # WINEPREFIX=~/.wine winetricks corefonts vcrun6 ffdshow xvid wsh57 wmp9 l3codecx lavfilters binkw32
        # WINEPREFIX=~/.wine Warcraft\ III.exe -opengl or (with version 1.29+) WINEPREFIX=~/.wine Warcraft\ III.exe -graphicsapi OpenGL2
        wineWowPackages.stable
        winetricks
        # gst_all_1.gstreamer
        (lutris.override {
          extraLibraries = pkgs: [];
          extraPkgs = pkgs: [];
        })

        wev
      ];
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };
    };

    wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
      ];
    };

    # Dark Mode for GNOME and GNOME apps
    dconf = {
        enable = true;
        # NOTE: Disabled in favor of stylix
        settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";
    };

    # Locations:
    # ~/.local/share/applications
    # /run/current-system/sw/share/applications
    # ~/.local/state/nix/profiles/home-manager/home-path/share/applications.
    xdg.mimeApps = {
      enable = true; # .config/mimeapps.list
      defaultApplications = {
        "text/html" = "brave.desktop";
        "image/jxl" = "swayimg.desktop";
        "image/jpg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "video/mp4" = "io.github.celluloid_player.Celluloid.desktop";
        "video/mkv" = "io.github.celluloid_player.Celluloid.desktop";
        "audio/mp3" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "audio/aac" = "vlc.desktop";
        "audio/m4a" = "vlc.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "x-scheme-handler/http" = "brave.desktop";
        "x-scheme-handler/https" = "brave.desktop";
        "x-scheme-handler/about" = "brave.desktop";
        "x-scheme-handler/unknown" = "brave.desktop";
      };
      associations.added = {
        "image/jxl" = [
          "swayimg.desktop"
          "koko.desktop"
        ];
      };
    };

    xdg.desktopEntries.swayimg = {
      name = "Swayimg";
      genericName = "Image Viewer";
      comment = "Fast and lightweight image viewer for Sway and Wayland";
      exec = "${pkgs.swayimg}/bin/swayimg %F";
      icon = "swayimg"; # if swayimg ships an icon, otherwise point to another icon
      categories = [ "Graphics" "Viewer" ];
      mimeType = [
        "image/png"
        "image/jpeg"
        "image/jxl"
        "image/gif"
        "image/webp"
        "image/bmp"
      ];
      terminal = true;
      type = "Application";
    };

    programs = {
        ssh.enable = true;
        direnv.enable = true;
        # llm.enable = true;
        wofi.enable = true;
        nushell.enable = true;
    };
    
}