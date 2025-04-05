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

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
    gamemode.enable = true;
  };

  environment.systemPackages = [
    pkgs.mangohud
    pkgs.gamescope
    pkgs.protonvpn-gui
  ];

  # gamescope -W 3840 -H 1600 -r 119 -f -e -- mangohud gamemoderun %command%

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  security.sudo = {
    # Only `wheel` group users can execute sudo
    execWheelOnly = true;
    # Always ask for sudo password!
    configFile = ''
      Defaults timestamp_timeout=0
    '';
  };
  
  sops.defaultSopsFile = ./secrets.yaml;
}
