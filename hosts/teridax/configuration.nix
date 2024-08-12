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

    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

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
