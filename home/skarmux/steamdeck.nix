{ pkgs, ... }:
{
  imports = [
    ./global 

    ./session/hyprland

    ./application/keepassxc
    ./application/imv.nix
    ./application/firefox.nix
    ./application/nextcloud.nix
    ./application/kdeconnect.nix
  ];

  monitors = [
    {
      name = ""; # TODO: check with hyprctl
      width = 1280;
      height = 800;
      refreshRate = 60;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];

  xdg.enable = true;

  # TODO: Find a way to use `skarmux` as main user on deck
  #home.username = "deck";

  home.packages = with pkgs; [
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel
  ];
}
