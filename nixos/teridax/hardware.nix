{ config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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
      # Enable builtin keyboard on boot screen to unlock bcachefs
      # https://discussion.fedoraproject.org/t/fujitsu-lifebook-e5510-keyboard-not-detected/70907/18
      "i8042.nomux=1"
      "i8042.reset"
    ];
    extraModulePackages = [ ];
  };

  networking = {
    useDHCP = lib.mkDefault true;
    interfaces.enp0s25.useDHCP = lib.mkDefault true;
    interfaces.wlp2s0.useDHCP = lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
