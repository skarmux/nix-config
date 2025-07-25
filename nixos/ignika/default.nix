{ self, inputs, pkgs, ... }:
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
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
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
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    # xserver = {
    #   enable = true;
    #   displayManager.setupCommands = "
    #     xrandr --output DP-1 --auto --primary
    #   ";
    # };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "skarmux";
      };
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        # theme = "";
      };
    };
    openssh.enable = true;
    openssh.settings.AllowUsers = [ "skarmux" ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
