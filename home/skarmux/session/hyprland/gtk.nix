{ config, pkgs, lib, ... }: {
  gtk = {
    enable = lib.mkDefault true;
    catppuccin = {
      enable = true;
      cursor.enable = true;
      size = "standard";
      tweaks = [ "rimless" ];
    };
    font = {
      name = config.fontProfiles.regular.family;
      size = 12;
    };
    # https://github.com/catppuccin/papirus-folders
    # Set by catppuccin/nix
    # iconTheme = {
    #   name = lib.mkDefault "Papirus";
    #   package = pkgs.papirus-icon-theme;
    # };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
