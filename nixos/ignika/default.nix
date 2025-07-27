{ self, inputs, pkgs, config, ... }:
{
  imports = [
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
      allowedTCPPorts = [ ];
      allowedUDPPorts = [
        # FIXME: Open the port only when the application is running
        # 24727 # AusweisApp2 Geräte Kopplung NFC Scan
      ];
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

  # systemd = {
  #   services.NetworkManager-wait-online.enable = false;
  # };

  # One of my custom modules, enabling retroarch with a
  # gamescope session
  arcade.enable = true;

  system.stateVersion = "25.05";

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L" # print build logs
  #   ];
  #   dates = "02:00";
  #   randomizedDelaySec = "45min";
  # };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        # Prevent boot partition from running out of disk space.
        configurationLimit = 10;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
  };

  services = {
    udev.packages = [ pkgs.dolphin-emu ];
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    # greetd = {
    #   enable = true;
    #   settings = rec {
    #     # default_session = {
    #     #   command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
    #     # };
    #     initial_session = {
    #       command = "Hyprland";
    #       user = "skarmux";
    #     };
    #     default_session = initial_session;
    #   };
    # };
    displayManager = {
      autoLogin = {
        enable = false;
        user = "skarmux";
      };
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        # TODO: Install a theme
        #       https://www.reddit.com/r/NixOS/comments/14dlvbr/sddm_theme/
        theme = "";
      };
    };
    openssh.enable = false;
    openssh.settings.AllowUsers = [ "skarmux" ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        extraConfig = {
          # "wh-1000xm4" = {
          #   "monitor.bluez.rules" = [
          #     {
          #       matches = [
          #         {
          #           "device.name" = "-bluez_card.*";
          #           "device.product.id" = "";
          #           "device.vendor.id" = "";
          #         }
          #       ];
          #       actions = {
          #         update-props = {
          #           "bluez5.a2dp.ldac.quality" = "hq";
          #         };
          #       };
          #     }
          #   ];
          # };
        };
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
            wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
          '')
        ];
      };
    };
  };

  programs = {
    openvpn3.enable = true;
    yubikey-touch-detector.enable = true;
    kdeconnect.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
      nixd # nix language server
      overskride # manage bluetooth connections
    ] ++ [ inputs.quickshell.packages.${pkgs.system}.default ];
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

  security = {
    sudo.execWheelOnly = true;
    rtkit.enable = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
