{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    ./disk.nix
    ./hardware.nix
    ./users/skarmux.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  mods.gnome.enable = true;

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "skarmux";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
