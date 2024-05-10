{ pkgs, ... }:
{
  imports = [
    ./global
    ./session/hyprland
    ./device/monitor/lgcx.nix
  ];

  gtk.cursorTheme.size = 32;

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
