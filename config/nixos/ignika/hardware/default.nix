{
  imports = [
    ./nvidia
    # ./openrgb.nix
    ./disk.nix
    ./audio.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "sd_mod" # SCSI, SATA, and PATA (IDE) devices
      "ahci" # SATA devices on modern AHCI controllers
      "nvme" # NVMe drives (really fast SSDs)
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid" # USB Human Interface Devices
      "xhci_pci" # USB 3.0 (eXtensible Host Controller Interface)
    ];
    kernelModules = [ "kvm-amd" "k10temp" "i2c-dev" ];
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  powerManagement.cpuFreqGovernor = "performance";

  monitors = {
    "BNQ BenQ RD280UA HAR0021601Q" = {
      primary = true;
      port = "DP-1";
    };
    "LG Electronics LG TV SSCR2 0x01010101" = {
      port = "HDMI-A-1";
    };
  };

  hardware = {
    # TODO: I got error messages during boot, so I'm setting
    #       this to `false` for now.
    cpu.amd.updateMicrocode = false; # Allow firmware updates
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless.enable = true;
    enableRedistributableFirmware = true;
  };  
}
