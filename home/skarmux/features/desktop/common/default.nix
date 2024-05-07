{ pkgs, ... }:
{
  imports = [
    ./font.nix
    ./alacritty.nix
    ./dunst.nix
    ./firefox.nix
    ./qt.nix
    ./gtk.nix
    ./keepassxc
    ./kdeconnect.nix
    ./thunar.nix
    ./bluetooth.nix
    ./scrcpy.nix
    ./steam.nix
    ./librewolf
  ];

  home.sessionVariables = { XCURSOR_SIZE = "32"; };

  home.packages = with pkgs; [
    chromium # browser

    # messenger
    signal-desktop
    element-desktop

    # media
    gimp
    audacity
    obsidian
    celluloid
    plexamp
    plex-media-player
  ];

  programs.imv = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.zathura = {
    enable = true;
    catppuccin.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  # Allow Nix to manage default application list
  xdg.enable = true;
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/apng" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
    };
  };

}
