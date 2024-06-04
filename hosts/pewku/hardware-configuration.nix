{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4".i2c1.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "uas" "pcie_brcmstb" "usbhid" ];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/" = {
      device = "/dev/sda2";
      fsType = "ext4";
    };
  };

  swapDevices = [];

  networking = {
    useDHCP = true;
    # useNetworkd = true;
    # interfaces.enabcm6e4ei0.useDHCP = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
