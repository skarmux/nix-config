{ inputs, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    ../common/global
    ../common/users/skarmux
    # ./services/feaston.nix
  ];

  services.nginx.enable = true;
  # services.nginx.virtualHosts."skarmux.ddns.net" = {
  #   root = "${inputs.feaston}/";
  # };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    initrd.availableKernelModules = [
      "usb_storage" # Utilize USB Mass Storage (USB flash drives)
      "usbhid" # USB Human Interface Devices
      "xhci_pci" # USB 3.0 (eXtensible Host Controller Interface)
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Required binary blobs to boot on this machine
  hardware = { enableRedistributableFirmware = true; };

  # Enable argonone fan daemon
  services.hardware.argonone.enable = true;

  powerManagement.cpuFreqGovernor = "ondemand";

  hardware.raspberry-pi."4".i2c1.enable = true;

  environment.systemPackages = with pkgs; [ panamax ];

  networking = {
    hostName = "pewku";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  # This is the root filesystem containing NixOS
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
