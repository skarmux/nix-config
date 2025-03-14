{
  imports = [
    ./nvidia
    # ../common/optional/gamemode.nix
    # ../common/optional/steam-hardware.nix
    ./disk-configuration.nix

    # Audio
    ../common/optional/pipewire.nix
  ];

  services.blueman.enable = true;
  # services.protonvpn.enable = true;

  # Required binary blobs to boot on this machine
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.amd.updateMicrocode = true; # Allow firmware updates
    bluetooth.enable = true;
    keyboard.zsa.enable = true;
  };

  networking = {
    hostName = "ignika";
    useDHCP = false; # enable per interface manually
    interfaces = {
      enp5s0.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";

  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";
}
