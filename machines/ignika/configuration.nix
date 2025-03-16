{ pkgs, config, ... }:
{
  imports = [
    ../../users/skarmux

    ../common
    # ../common/optional/greetd.nix
    # ../common/optional/hyprland.nix
    # ../common/optional/thunar.nix
    ../common/optional/gpg.nix

    ./hardware-configuration.nix
  ];

  # Turn on all features related to desktop and graphical applications
  boot = {
    loader = {
      timeout = null; # show boot selection indefenitely
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" "bcachefs" ];
  };

  networking.hostName = "ignika";

  services.xserver.enable = true;
  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "skarmux";
  };
  services.desktopManager.plasma6.enable = true;

  programs.firefox.enable = true;

  users.users."skarmux" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.openssh.settings.AllowUsers = [ "skarmux" ];

  nix.settings.trusted-users = [ "skarmux" ];

  environment.systemPackages = with pkgs; [
    # android-udev-rules # screen mirroring with scrpy and adb
    # deluge # torrenting client
  ];

  home-manager.users."skarmux" = {
    monitors = [
      # {
      #   name = "DP"; # BenQ
      #   width = 3840;
      #   height = 2560;
      #   refreshRate = 60;
      #   x = 3840;
      #   vrr = false;
      #   hdr = true;
      #   workspace = "1";
      #   primary = true;
      # }
      {
        name = "HDMI-A-1"; # LG Electronics LG TV SSCR2 0x01010101
        width = 3840;
        height = 2160;
        refreshRate = 60; # TODO Set to 60 for compatibility reasons
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
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          # Set RefreshRate to 120 using wlr-randr after Hyprland startup
          "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --mode 3840x2160@119.879997Hz --scale 1"
        ];
      };
    };
  };
}
