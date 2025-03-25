{ pkgs, ... }:
{
  imports = [
    ./nvidia
  ];

  boot = {
    initrd.availableKernelModules = [
      "sd_mod"      # SCSI, SATA, and PATA (IDE) devices
      "ahci"        # SATA devices on modern AHCI controllers
      "nvme"        # NVMe drives (really fast SSDs)
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid"      # USB Human Interface Devices
      "xhci_pci"    # USB 3.0 (eXtensible Host Controller Interface)
    ];
    kernelModules = [ "kvm-amd" "k10temp" "i2c-dev" ];
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  powerManagement.cpuFreqGovernor = "performance";

  hardware.cpu.amd.updateMicrocode = true; # Allow firmware updates

  hardware.enableRedistributableFirmware = true;
}
