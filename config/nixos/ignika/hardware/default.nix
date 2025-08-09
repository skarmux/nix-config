{
  imports = [
    ../../../hardware/voyager.nix
    ../../../hardware/benq_rd280ua.nix
    ../../../hardware/lg_tv_sscr2
    ../../../hardware/sony_wh-xm4-1000.nix
    ../../../hardware/yubikey
    ../../../hardware/logitech_g502.nix
    ../../../hardware/sony_dualsense.nix
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
    benq = {
      port = "DP-1";
      primary = true;
    };
    lgcx = {
      port = "HDMI-A-1";
      enabled = false;
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
    logitech.wireless.enable = true; # FIXME Move to config/hardware
    enableRedistributableFirmware = true;
  };  
}
