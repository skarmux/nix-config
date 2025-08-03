{ pkgs, ... }:
{
  imports = [
    ./hardware
    ./users
    ../../optional/hyprland.nix
  ];

  system.stateVersion = "25.05";

  networking.hostName = "teridax";
  
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  environment = {
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

  home-manager.users.skarmux = {
    wayland.windowManager.hyprland = {
      settings = {
        gestures.workspace_swipe = "on";

        input.touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
        };

        master = { no_gaps_when_only = true; };
        dwindle = { no_gaps_when_only = true; };

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

  sops.defaultSopsFile = ./secrets.yaml;
}
