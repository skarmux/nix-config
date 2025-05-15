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
  # boot.kernelPackages = pkgs.linuxPackages_6_14;

  # mods.gnome.enable = true;
  mods.hyprland.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # OpenVPN
  services.openvpn.servers = {
    # hacktheboxVPN = {
    #   config = ''
    #     config ${config.sops.secrets."openvpn/hackthebox".path}
    #     config ${../../keys/starting_point_Skarmux.ovpn}
    #   '';
    #   autoStart = false;
    # };
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      # pkgs.noto-fonts-cjk-serif # for games with japanese fonts
      # pkgs.nerd-fonts.jetbrains-mono # upcoming
    ];
  };
  
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      # settings = {
      #   Autologin = {
      #     Session = "hyprland-uwsm";
      #     User = "skarmux";
      #   };
      # };
    };
  };

  # TODO: What for?
  # services.xserver.enable = true;

  services = {
    # displayManager = {
    #   autoLogin.enable = true;
    #   autoLogin.user = "skarmux";
    # };
    getty.autologinUser = "skarmux";
    openssh = {
      enable = true;
      settings.AllowUsers = [ "skarmux" ];
    };
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = false;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    gamescope = {
      enable = false;
      capSysNice = true;
    };
    gamemode.enable = true;
  };

  environment = {
    # loginShellInit = ''
    #   [[ "$(tty)"  = "/dev/tty1" ]] && ./gamescope.sh
    # '';
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
      nixd
      mangohud
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
  
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "openvpn/hackthebox" = {};
    };
  };
}
