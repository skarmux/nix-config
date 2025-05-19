{ self, inputs, pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./disk.nix
    ./hardware.nix
    ./users
    ./steam.nix
    ../common/home-manager.nix
    ../common/hyprland
    ../common/locale.nix
    ../common/nix.nix
    ../common/openssh.nix
    ../common/sops.nix
    inputs.impermanence.nixosModules.impermanence
  ] ++ builtins.attrValues self.nixosModules;

  networking = {
    hostName = "ignika";
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPortRanges = [
        # { from = 4000; to = 4007; } # example
      ];
      interfaces = {
        "eth0" = {
          # allowed[...]Port(s) = {};
        };
      };
    };
    networkmanager.enable = true;
  };

  arcade.enable = true;

  system.stateVersion = "24.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = [
      (pkgs.nerdfonts.override { fonts = [
        "JetBrainsMono"
        "FiraCode"
      ]; })
    ];
  };
  
  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "skarmux";
      defaultSession = "hyprland-uwsm";
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
    openssh.enable = true;
    openssh.settings.AllowUsers = [ "skarmux" ];
  };

  programs = {
    openvpn3.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
      nixd # nix language server
      overskride # manage bluetooth connections
    ];
    sessionVariables = {
      XDG_BACKEND = "wayland";
      # XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      LIBSEAT_BACKEND = "logind";
    };
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

  security.sudo.execWheelOnly = true;
  
  sops.defaultSopsFile = ./secrets.yaml;
}
