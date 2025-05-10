{ self, inputs, pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./disk.nix
    ./hardware.nix
    ./users
    inputs.impermanence.nixosModules.impermanence
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
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = false;
    };
    gamemode.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamescope
        mangohud
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
    ];
    persistence."/persist" = {
      hideMounts = true; # hide in desktop applications like nautilus or dolphin
      directories = [
        "/home"
        # Store all logs
        "/var/log"
        # User configuration, etc.
        "/var/lib/nixos"
        # System crash dumps for analysis
        "/var/lib/systemd/coredump"
      ];
      files = [
        # FIXME bind-mount fails on startup
        # https://discourse.nixos.org/t/impermanence-a-file-already-exists-at-etc-machine-id/20267
        # "/etc/machine-id"
      ];
    };
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen;

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
