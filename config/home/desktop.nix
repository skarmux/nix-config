{ pkgs, lib, ... }:
{
    imports = [
        ./modules/stylix.nix
        ./programs/alacritty.nix
        ./programs/hyprland.nix
        # ./programs/dunst.nix # NOTE: Notifications handled by caelestia-shell
        ./programs/wofi.nix
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
        imv # tiled image viewer
        libjxl # jpeg xl
        celluloid # video player
        plexamp # music streaming
        gimp # raster graphics
        inkscape # vector graphics
        grayjay

        keepassxc # password management
        obsidian # notetaking
        libreoffice # office

        # hyprland
        grim
        slurp
        swappy
        nautilus

        deluge

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
        
      ];
    };

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

    programs = {
        ssh.enable = true;
        direnv.enable = true;
        # llm.enable = true;
        wofi.enable = true;
        nushell.enable = true;
    };
    
}