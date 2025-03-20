{ pkgs, ... }:
{
  imports = [
    ./nvidia
    # ../common/optional/gamemode.nix
    # ../common/optional/steam-hardware.nix

    ./disk-configuration.nix

    # Audio
    ../common/optional/pipewire.nix
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # services.protonvpn.enable = true;

  boot = {

    initrd.availableKernelModules = [
      "sd_mod"      # SCSI, SATA, and PATA (IDE) devices
      "ahci"        # SATA devices on modern AHCI controllers
      "nvme"        # NVMe drives (really fast SSDs)
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid"      # USB Human Interface Devices
      "xhci_pci"    # USB 3.0 (eXtensible Host Controller Interface)
    ];

    kernelModules = [
      "kvm-amd"
      "k10temp"
      "i2c-dev" # device control
    ];

    kernelPackages = pkgs.linuxPackages_zen;

    # Enables this machine to build and deploy to aarch64 targets
    # I need this to deploy to my raspberry pi
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking = {
    hostName = "ignika";
    useDHCP = false; # enable per interface manually
    interfaces = {
      enp5s0.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  # Required binary blobs to boot on this machine
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.amd.updateMicrocode = true; # Allow firmware updates
  };
}
