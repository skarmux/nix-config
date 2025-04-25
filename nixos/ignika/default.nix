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
      virtualHosts."feaston.localhost" = {
        # FIXME Temporarily disable ACME for local testing
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
    };
  };

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
  };

  environment.systemPackages = [
    # pkgs.anubis
    pkgs.mangohud
    pkgs.gamescope
    pkgs.protonvpn-gui # NOTE: Needs to be system level, I think
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

    # FIXME Temporarily disable ACME for local testing
    # acme = {
    #   acceptTerms = true;
    #   defaults.email = "admin@skarmux.tech";
    # };
  };
  
  sops.defaultSopsFile = ./secrets.yaml;
}
