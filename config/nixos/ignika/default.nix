{ pkgs, ... }:
{
  imports = [
    ./hardware
    ./programs
    ./services
    ./users
    ../../optional/hyprland.nix
    ../../optional/nautilus.nix
    ./vm/kvm.nix
  ];

  system.stateVersion = "25.05";

  networking = {
    hostName = "ignika";
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowedUDPPortRanges = [
        # { from = 4000; to = 4007; } # example
      ];
      interfaces = {
        "eth0" = {
          # allowed[...]Port(s) = {};
        };
        # TODO: Add vpn interfaces here as well?
      };
    };
    networkmanager.enable = true;
  };

  yubico = {
    authorizeSSH = true;
    passwordlessSudo = true;
    authenticatorApp = true;
  };

  retroSession.enable = true;

  boot = {
    loader = {
      timeout = 30; # seconds to wait for nixos generation selection
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        # Prevent boot partition from running out of disk space.
        configurationLimit = 10;
      };
    };
    binfmt.emulatedSystems = [
      # Allows building packages for `pewku` during remote deployment
      "aarch64-linux"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs.nerd-fonts; [
      jetbrains-mono
      fira-code
    ];
  };

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "skarmux";
      };
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  programs = {
    openvpn3.enable = true; # hackthebox
    kdeconnect.enable = true;
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
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
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
        # SSH
        "/etc/ssh"
      ];
    };
  };

  security = {
    sudo.execWheelOnly = true;
    rtkit.enable = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
