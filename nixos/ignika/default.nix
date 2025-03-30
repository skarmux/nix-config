{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    ./disk.nix
    ./hardware.nix
    ./users/skarmux.nix
  ] ++ builtins.attrValues self.nixosModules;

  networking.hostName = "ignika";

  system.stateVersion = "24.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  mods.gnome.enable = true;

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "skarmux";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  sops.defaultSopsFile = ./secrets.yaml;
}
