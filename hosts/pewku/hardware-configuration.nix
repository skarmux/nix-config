{ lib, ... }:
{
  imports = [
    # ./disk-configuration.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "uas" ];
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
