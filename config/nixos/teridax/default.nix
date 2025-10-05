{ pkgs, config, ... }:
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

    wg-quick.interfaces = {
      wg0 = {
        address = [
          "fdff:6b24:52ad::203/64"
          "192.168.178.203/24"
        ];
        dns = [
          "127.0.0.1"
          "192.168.178.1"
          "fdff:6b24:52ad::3e37:12ff:fe97:e724"
          "fritz.box"
        ];
        privateKeyFile = config.sops.secrets."wireguard/private".path;
        peers = [
          {
            publicKey = "mydye9u8xkPXtxfEbLQ/hrbTX7moTPbmJXhd+vDQwnc=";
            presharedKeyFile = config.sops.secrets."wireguard/preshared".path;
            allowedIPs = [
              "192.168.178.0/24"
              "0.0.0.0/0"
              "fdff:6b24:52ad::/64"
              "::/0"
            ];
            endpoint = "5ehy71rcjgchb3e5.myfritz.net:56998";
            persistentKeepalive = 25;
          }
        ];
      };
    };
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

  security = {
    sudo.execWheelOnly = true;
    rtkit.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      # "wireguard" = {
      #   mode = "400";
      #   owner = "skarmux";
      #   group = config.users.users.skarmux.group;
      # };
    };
  };
}
