{ pkgs, ... }:
{
  imports = [
    ./global 

    ./session/hyprland

    # ./application/keepassxc
    # ./application/imv.nix
    ./application/firefox.nix
    # ./application/nextcloud.nix
    # ./application/kdeconnect.nix
  ];

  home.username = "deck";

  monitors = [
    {
      name = "X11-1";
      width = 1280;
      height = 800;
      refreshRate = 60;
      x = 0;
      vrr = true;
      hdr = false;
      workspace = "1";
      primary = true;
    }
  ];

  xdg.enable = true;

  home.packages = with pkgs; [
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel
    # home-manager
    # git
    # openssh
    # sops
  ];
}
