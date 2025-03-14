{ pkgs, config, ... }:
{
  imports = [
    ../../users/skarmux

    ../common
    # Desktop Environment
    ../common/optional/greetd.nix
    # ../common/optional/hyprland.nix
    # ../common/optional/thunar.nix
    ../common/optional/gpg.nix

    # No longer required due to dual booting with
    # two ssd
    # ./kvm.nix

    ./hardware-configuration.nix
  ];

  # Turn on all features related to desktop and graphical applications
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    initrd.availableKernelModules = [
      "sd_mod"      # SCSI, SATA, and PATA (IDE) devices
      "ahci"        # SATA devices on modern AHCI controllers
      "nvme"        # NVMe drives (really fast SSDs)
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid"      # USB Human Interface Devices
      "xhci_pci"    # USB 3.0 (eXtensible Host Controller Interface)
    ];

    kernelModules = [ "kvm-amd" "k10temp" /* device control */ "i2c-dev" ];

    # Enables this machine to build and deploy to aarch64 targets
    # I need this to deploy to my raspberry pi
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Enable mounting and exploring of the windows drive
    supportedFilesystems = [ "ntfs" ];

    loader = {
      timeout = null; # show boot selection indefenitely
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = config.boot.loader.efi.canTouchEfiVariables;
        useOSProber = true; # Check for other OSes and make them available
        configurationLimit = 10; # Limit nixos generations display
        # Install GRUB onto the boot disk
        #device = config.fileSystems."/boot".device;
        # OR
        # Don't install GRUB. TODO: Required for UEFI?
        device = "nodev";
      };
    };
  };

  # programs = {
  #   adb.enable = true;
  #   kdeconnect.enable = true;
  # };

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
