{ pkgs, ... }:
{
  imports = [
    ./hardware
    # ./programs
    # ./services
    ./users
    ../../optional/hyprland.nix
    ../../optional/nautilus.nix
  ];

  system.stateVersion = "25.05";

  networking = {
    hostName = "teridax";
    firewall = {
      enable = true;
      # interfaces = {
      #   "eth0" = {};
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
    openvpn3.enable = true;
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
      ];
    };
  };

  security = {
    sudo.execWheelOnly = true;
    rtkit.enable = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;

  home-manager.users.skarmux = {
    wayland.windowManager.hyprland = {
      settings = {
        gestures.workspace_swipe = "on";

        input.touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
        };

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          # cursor_inactive_timeout = 5; # seconds
          layout = "dwindle";
        };
      };

      # Builtin keyboard is either/both of those devices
      extraConfig = ''
        device {
          name = fujitsu-fuj02e3
          kb_layout=de
          numlock_by_default=false
        }
        device {
          name = at-translated-set-2-keyboard
          kb_layout=de
          numlock_by_default=false
        }
      '';
    };

    programs.waybar.settings.primary = {
      battery.bat = "CMB1";
    };
 
  };

}