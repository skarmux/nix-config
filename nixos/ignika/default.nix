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

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  sops.secrets = {
    skarmux-password = {
      neededForUsers = true;
      sopsFile = ./secrets.yaml;
    };
  };
  
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "skarmux";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
