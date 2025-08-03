{ pkgs, ... }:
{
    imports = [
        ./modules/stylix.nix
        ./programs/alacritty.nix
        ./programs/hyprland.nix
        ./programs/dunst.nix
        ./programs/wofi.nix
        ./services/hyprpaper.nix
    ];

    home = {
        packages = with pkgs; [
            insomnia # api checking
            # vscode # graphical editor
            
            # browser
            firefox
            brave

            # messenger
            # discord-ptb
            element-desktop
            signal-desktop
            telegram-desktop

            # multimedia
            evince # pdf viewer
            imv # tiled image viewer
            libjxl # jpeg xl
            celluloid # video player
            # plexamp # music streaming
            gimp # raster graphics
            inkscape # vector graphics

            keepassxc # password management
            # obsidian # notetaking
            libreoffice # office

            # hyprland
            grim
            slurp
            swappy
            nautilus
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