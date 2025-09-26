{ pkgs, ... }:
{
  imports = [
    ./hardware
    ./programs
    ./services
    ./users
    ./vm
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
      # timeout = 30; # seconds to wait for nixos generation selection
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

  environment = {
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
      nixd # nix language server
      pavucontrol
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

  # TODO: Implement ZRAM swap:
  # https://pocketcasts.com/podcast/linux-matters/057042f0-be09-013b-f3ff-0acc26574db2/a-mini-swap-adventure/361fe2c7-1c9f-4060-91c4-5c4fe9d9d803
  swapDevices = [
    { device = "/swapfile"; size = 16 * 1024; /* 16 GB */ }
  ];

  security = {
    sudo.execWheelOnly = true;
    rtkit.enable = true;
    # Unlock kwallet with user login
    # - Has to use same as user password for encryption
    pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
