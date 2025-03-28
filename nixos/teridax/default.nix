{ inputs, pkgs, ... }:
{
  imports = [
    ./disk.nix
    ./hardware.nix
    ./users/skarmux.nix
    # ./hyprland.nix
  ];

  networking.hostName = "teridax";

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "bcachefs" "ntfs" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
