{ self, pkgs, lib, ... }:
{
  imports = [
    ./audio.nix
    ./disk.nix
    ./hardware.nix
    ./users
  ] ++ builtins.attrValues self.nixosModules;

  networking.hostName = "ignika";

  system.stateVersion = "24.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  mods.gnome.enable = true;

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = [
      pkgs.vistafonts
      pkgs.corefonts
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      # pkgs.nerd-fonts.jetbrains-mono # upcoming
    ];
  };
  
  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "skarmux";
    };
    openssh = {
      enable = true;
      settings.AllowUsers = [ "skarmux" ];
    };
    nginx = {
      enable = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };
  };

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
    # Required for impermanence home-manager option `fuse.allowOther = true`
    fuse.userAllowOther = true;
  };

  environment.systemPackages = with pkgs; [
    protonvpn-gui # NOTE: Needs to be system level, I think
    helix
    git
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  security = {
    sudo = {
      # Only `wheel` group users can execute sudo
      execWheelOnly = true;
      # Always ask for sudo password!
      # configFile = ''
      #   Defaults timestamp_timeout=0
      # '';
    };
  };
  
  sops.defaultSopsFile = ./secrets.yaml;
}
