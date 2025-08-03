{
  imports = [
    ./disk.nix
  ];
  
  hardware.raspberry-pi."4".i2c1.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "uas" "pcie_brcmstb" "usbhid" ];

  # networking = {
  #   # FIXME Move to tailscale module if important enough
  #   # Disable DHCP by default and enable it per interface
  #   # to make tailscale magicDNS work properly
  #   useDHCP = false;
  #   interfaces.enabcm6e4ei0.useDHCP = true;
  # };

  powerManagement.cpuFreqGovernor = "ondemand";

  nixpkgs.hostPlatform.system = "aarch64-linux";
}