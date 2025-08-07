{ pkgs, ... }:
{
  imports = [
    ./disk.nix
  ];

  boot = {
    initrd = {
      # Minimal list of modules to use the EFI system partition and the YubiKey
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      # Enable support for the YubiKey PBA
      luks.yubikeySupport = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
      ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      # Enable builtin keyboard on initramfs screen to unlock luks encrypted drive
      # https://discussion.fedoraproject.org/t/fujitsu-lifebook-e5510-keyboard-not-detected/70907/18
      "i8042.nomux=1"
      "i8042.reset"
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = "ondemand";

  monitors = {
    "Embedded" = {
      primary = true;
      port = "eDP-1";
      width = 1600;
      height = 900;
      refresh = 59.985;
    };
    "LG Electronics 22MB65 501NDEZA2964" = {
      port = "DP-2";
      width = 1680;
      height = 1050;
      refresh = 59.883;
    };
  };

  networking = {
    interfaces = {
      enp0s25.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    logitech.wireless.enable = true; # FIXME Move to config/hardware
    enableRedistributableFirmware = true;
  };

  #############
  ### AUDIO ###
  #############

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber = {
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];
    };
  };

}
