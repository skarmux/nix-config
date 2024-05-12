{ pkgs, ... }:
{
  imports = [
    ./global
    ./session/hyprland
    ./device/monitor/lgcx.nix
  ];

  gtk.cursorTheme.size = 32;

  # LG Electronics LG TV SSCR2 0x01010101
  monitors = [
    {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      x = 0;
      vrr = true;
      hdr = true;
      workspace_padding = { top = 700; };
      workspace = "1";
      primary = true;
    }
  ];

  # Hide static elements from OLED monitor
  programs.waybar.enable = false;

  # HOTFIX: Hyprland can't initialize monitor with HDMI 2.1 spec 
  home.packages = with pkgs; [ wlr-randr ];
  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        # Set RefreshRate to 120 using wlr-randr after Hyprland startup
        "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --mode 3840x2160@119.879997Hz --scale 1"
      ];
    };
  };
}
