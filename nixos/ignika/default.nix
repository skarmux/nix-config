{ self, inputs, pkgs, config, ... }:
let
  # replacing `-tenfoot` with `-steamos3 -gamepadui` to make `Exit to Desktop` quit the session.
  # yes, it works. :)
  steam-gamescope = let
    exports = builtins.attrValues (
      builtins.mapAttrs (n: v: "export ${n}=${v}") config.programs.steam.gamescopeSession.env
    );
  in pkgs.writeShellScriptBin "steam-gamescope" ''
    # ${builtins.concatStringsSep "\n" exports}
    MANGOHUD=1
    MANGOHUD_CONFIG=fps,frametime,fsr,hdr,gamemode,wine,hud_compact,frame_timing,cpu_stats,gpu_stats
    gamescope --steam -r 50 --hdr-enabled --mangoapp -- steam -steamos3 -gamepadui
  '';
  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam Custom
      Comment=A digital distribution platform
      Exec=${steam-gamescope}/bin/steam-gamescope
      Type=Application
    '').overrideAttrs(_: {
      passthru.providedSessions = [ "steam" ];
    });
in
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

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
  
  services.displayManager = {
    sessionPackages = [ gamescopeSessionFile ];
    # will be pre-selected in the greeter
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

  services = {
    # displayManager = {
    #   autoLogin.enable = true;
    #   autoLogin.user = "skarmux";
    # };
    openssh = {
      enable = true;
      settings.AllowUsers = [ "skarmux" ];
    };
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true; # TODO: Writing my own session since I need to attach certain flags to steam
        args = [ "-r 50" "--mangoapp" "--hdr-enabled" ];
        env = {
          MANGOHUD = "true";
          MANGOHUD_CONFIG = "fps,frametime,fsr,hdr,gamemode,wine,hud_compact,frame_timing,cpu_stats,gpu_stats";
        };
      };
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      # package = pkgs.steam.override {
      #   extraEnv = { };
      # };
      extraPackages = with pkgs; [
        # mangohud
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      # extest.enable = true;
    };
    gamescope.capSysNice = false; # FIXME Can't set this to `true`. Gamescope crashes on startup.
    # TODO: Activate gamemode with steam session
    gamemode.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      protonvpn-gui # NOTE: Needs to be system level, I think.
      helix
      git
      nixd
      # Use `Switch to Desktop` option to close the gamescope session
      (pkgs.writeShellScriptBin "steamos-session-select" "steam -shutdown")
      mangohud # TODO: Do need it on system level to be used by the gamescope session??
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
