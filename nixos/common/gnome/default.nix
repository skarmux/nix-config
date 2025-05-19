{ pkgs, config, lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # HOTFIX: Auto Login
  systemd.services = lib.mkIf config.services.displayManager.autoLogin.enable {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    switcher        # App Launcher/Switcher
    just-perfection # Tweak Gnome Shell
    transparent-top-bar
  ];

  # Part of App Indicator
  # TODO: Can I remove this? Check GNOME on NixOS wiki
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  home-manager.users.skarmux = {
    # FIXME: I think I don't need this after removing gnome-tour
    # file.".config/gnome-initial-setup-done".text = "yes";
    # dconf = {
    #   enable = true;
    #   "org/gnome/shell" = {
    #     disable-user-extensions = false; # enables user extensions
    #     enabled-extensions = with pkgs.gnomeExtensions; [
    #       switcher.extensionUuid
    #       just-perfection.extensionUuid
    #       transparent-top-bar.extensionUuid
    #     ];
    #   };
    #   "org/gnome/shell/extensions/switcher" = {
    #     font-size = "uint32 14"; # TODO: Match with system font size
    #     show-switcher = ["<Control>space"];
    #     ordering = "uint32 1";
    #     workspace-indicator = false;
    #     max-width-percentage = "uint32 40";
    #     matching = "uint32 1"; # fuzzy matching
    #   };
    #   "org/gnome/desktop/input-sources" = {
    #     mru-sources = ["('xkb', 'us')"];
    #     sources = ["('xkb', 'us+altgr-ints')"];
    #     xkb-options = [
    #       "terminate:ctrl_alt_bksp"
    #       "lv3:ralt_switch"
    #     ];
    #   };
    #   "org/gnome/desktop/interface" = {
    #     clock-show-seconds = false;
    #     clock-show-weekday = true;
    #     color-scheme = "prefer-dark";
    #     enable-animations = true;
    #     enable-hot-corners = false;
    #   };
    #   "org/gnome/desktop/peripherals/mouse" = {
    #     accel-profile = "flat";
    #     speed = 0.0;
    #   };
    #   "org/gnome/desktop/wm/preferences" = {
    #     button-layout = "appmenu:minimize,maximize,close";
    #     focus-mode = "click";
    #     num-workspaces = 4;
    #     resize-with-right-button = true;
    #   };
    #   "org/gnome/shell/extensions/auto-move-windows" = {
    #     application-list = [
    #       "brave-browser.desktop:1"
    #       "discord.desktop:2"
    #       "element-desktop.destop:2"
    #       "com.mitchellh.ghostty.desktop:1"
    #       "org.keepassxc.KeePassXC.desktop:4"
    #       "signal-desktop.desktop:2"
    #       "org.telegram.desktop.desktop:2"
    #       "steam.desktop:3"
    #     ];
    #   };
    #   "org/gnome/shell/extensions/just-perfection" = {
    #     accessibility-menu = false;
    #     activities-button = false;
    #     animation = 1;
    #     clock-menu = true;
    #     dash = true;
    #     keyboard-layout = true;
    #     overlay-key = true;
    #     panel = true;
    #     power-icon = false;
    #     quick-settings-airplane-mode = false;
    #     ripple-box = true;
    #     startup-status = 0;
    #     support-notifier-showed-version = 34;
    #     support-notifier-type = 0;
    #     window-picker-icon = true;
    #     workspace = true;
    #     workspace-popup = false;
    #     workspace-wrap-around = false;
    #   };
    #   "org/gnome/desktop/wm/keybindings" = {
    #     move-to-workspace-1 = "['<Shift><Super>1']";
    #     move-to-workspace-2 = "['<Shift><Super>2']";
    #     move-to-workspace-3 = "['<Shift><Super>3']";
    #     move-to-workspace-4 = "['<Shift><Super>4']";
    #     switch-to-workspace-1 = "['<Super>1']";
    #     switch-to-workspace-2 = "['<Super>2']";
    #     switch-to-workspace-3 = "['<Super>3']";
    #     switch-to-workspace-4 = "['<Super>4']";
    #   };
    # };
    # TODO: Persistence for /home is postponed
    # home.persistence."/persist/home/skarmux/.persist" = {
    #   directories = [
    #     ".config/dconf"
    #     ".config/gnome-session"
    #     ".local/share/gvfs-metadata"
    #     ".local/share/backgrounds"
    #   ];
    # };
  };

  # Trim GNOME default software
  environment.gnome.excludePackages = with pkgs; [
    orca # screen reader
    # gnome-disk-utility
    atomix   # puzzle game
    cheese   # webcam tool
    epiphany # web browser
    # evince # document viewer
    geary    # email reader
    gedit    # text editor
    # gnome-characters
    gnome-music
    gnome-photos
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-connections # remote desktop client
    yelp # help viewer
    gnome-software # app store
    # gnome-console # terminal emulator
    gnome-tour
    hitori   # sudoku game
    iagno    # go game
    tali     # poker game
    totem    # video player (broken on wayland)
  ];
}
