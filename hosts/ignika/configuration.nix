{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/skarmux

    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/gamemode.nix
    ../common/optional/steam-hardware.nix
    ../common/optional/thunar.nix
    ../common/optional/ollama.nix
    ../common/optional/hyprland.nix
    ../common/optional/gpg.nix

    ./kvm.nix
    ./nvidia
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
  # services.protonvpn.enable = true;

  # Turn on all features related to desktop and graphical applications
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    initrd.availableKernelModules = [
      "sd_mod" # SCSI, SATA, and PATA (IDE) devices
      "ahci" # SATA devices on modern AHCI controllers
      "nvme" # NVMe drives (really fast SSDs)
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid" # USB Human Interface Devices
      "xhci_pci" # USB 3.0 (eXtensible Host Controller Interface)
    ];
    kernelModules = [
      "kvm-amd"
      "k10temp"
      "i2c-dev" # device control
    ];
  };

  boot.loader = {

    # Use systemd bootloader
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };

    # Use GRUB bootloader
    grub = {
      enable = false;

      efiSupport = true;

      # Check for other OSes and make them available
      useOSProber = false;

      # Attempt to display GRUB on widescreen monitor
      gfxmodeEfi = "3840x2160";

      # Limit the total number of configurations to rollback
      configurationLimit = 10;

      # Install GRUB onto the boot disk
      # device = config.fileSystems."/boot".device;

      # Don't install GRUB. TODO: Required for UEFI?
      device = "nodev";
    };

    # Always display menu indefinitely; default is 5 sec
    # timeout = null;

    # Allow GRUB to interact with the UEFI/BIOS
    efi.canTouchEfiVariables = true;
  };

  # boot.supportedFilesystems = [ "ntfs" ];

  # Enables this machine to build and deploy to aarch64 targets
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Required binary blobs to boot on this machine
  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # Allow firmware updates
    cpu.amd.updateMicrocode = true;
  };

  programs = {
    adb.enable = true;
    kdeconnect.enable = true;
  };

  environment.systemPackages = with pkgs; [ 
    android-udev-rules 
    deluge
  ];

  hardware.keyboard.zsa.enable = true;

  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance"; # performance | powersave

  # Enable DHCP
  networking = {
    hostName = "ignika";
    useDHCP = false;
    interfaces = {
      # With intel wireless disabled
      # enp4s0.useDHCP = true;

      # With intel wireless enabled
      enp5s0.useDHCP = true;
      wlp4s0.useDHCP = false;
    };
  };

  # This is the root filesystem containing NixOS
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # This is the boot filesystem for GRUB
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
