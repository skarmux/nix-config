{ pkgs, ... }:
# TODO: Lock screen and suspend on lid close
{
  imports = [
    ./hardware
    # ./programs
    # ./services
    ./users
    ./vm
  ];

  system.stateVersion = "25.05";

  networking = {
    hostName = "teridax";
    firewall = {
      enable = true;
      # interfaces = {
      #   "eth0" = {};
      #   "wlp2s0" = {};
      # };
    };
    networkmanager.enable = true;
  };

  yubico = {
    authorizeSSH = true;
    passwordlessSudo = true;
    authenticatorApp = true;
  };
  
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    binfmt.emulatedSystems = [
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
        # After unlocking the luks drive with 2FA,
        # might as well do auto login. :)
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
    openvpn3.enable = true; # Only needed for home/hackthebox.nix
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