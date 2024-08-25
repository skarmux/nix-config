{ inputs, pkgs, ... }:
{
  imports = [
    ../common/global
    ../common/users/skarmux

    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/wireless.nix
    ../common/optional/thunar.nix
    ../common/optional/gpg.nix
    ../common/optional/nas.nix

    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = ["0.0.0.0:5232" "[::]:5232"];
      };
    };
  };

  environment.persistence."/nix/persist".users.skarmux = {
    directories = [
      "Documents"
      # { directory = ".gnupg"; mode = "0700"; }
      # { directory = ".ssh"; mode = "0700"; }

      # Plex Media Player
      # - Downloads
      # "Library"

      # Direnv
      # - List of allowed directories
      ".local/share/direnv"
      ".local/share/fish"
      ".local/share/nvim"

      # Syncthing
      # - Connection settings
      ".local/state/syncthing"

      # Firefox
      # - Extensions, Bookmarks, History, etc.
      ".mozilla"
    ];
    files = [
      # ".screenrc"
    ];
  };

  networking.hostName = "teridax";

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "bcachefs" "ntfs" ];
    loader.systemd-boot.enable = true;

    # Enable deployment to Raspberry Pi 4 (ARM64)
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Required binary blobs to boot on this machine
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Save power on idle and boost for compiles
  powerManagement.cpuFreqGovernor = "ondemand";

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.sessionVariables = {
    XDG_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    LIBSEAT_BACKEND = "logind";
  };
  # End Hyprland
}
