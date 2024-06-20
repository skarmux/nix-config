{ config, pkgs, lib, ... }: {
  gtk = {
    enable = lib.mkDefault true;
    font = {
      name = config.fontProfiles.regular.family;
      size = 12;
    };
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Vanilla";
      size = lib.mkDefault 32;
      package = pkgs.vanilla-dmz;
    };
    iconTheme = {
      name = lib.mkDefault "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
