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
      # options = [ "noexec" ];
    };
  };

  networking = {
    wireless.enable = false;
    # Disable DHCP by default and enable it per interface
    # to make tailscale work properly
    useDHCP = false;
    interfaces.enabcm6e4ei0.useDHCP = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
