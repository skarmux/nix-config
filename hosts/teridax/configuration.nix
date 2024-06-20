{ inputs, pkgs, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ./hardware-configuration.nix

    ../common/global
    ../common/users/skarmux

    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/wireless.nix
    ../common/optional/thunar.nix
    ../common/optional/nas.nix
    ../common/optional/gpg.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "bcachefs" "ntfs" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Required binary blobs to boot on this machine
  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking.hostName = "teridax";

  powerManagement.cpuFreqGovernor = "performance ";

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
}
