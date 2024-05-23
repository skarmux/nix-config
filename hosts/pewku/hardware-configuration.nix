{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4
    # ./disk-configuration.nix
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

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
