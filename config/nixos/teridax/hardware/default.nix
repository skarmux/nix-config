{ config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
      ];
    };
    kernelModules = [
      "kvm-intel"
    ];
    kernelParams = [
      # Enable builtin keyboard on boot screen to unlock luks encrypted drive
      # https://discussion.fedoraproject.org/t/fujitsu-lifebook-e5510-keyboard-not-detected/70907/18
      "i8042.nomux=1"
      "i8042.reset"
    ];
    extraModulePackages = [ ];
  };

  networking = {
    useDHCP = true;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = true;
}
