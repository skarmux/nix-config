{ pkgs, ... }:
{
  imports = [
    ./disk.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "rtsx_pci_sdmmc"
    ];
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
    # "<builtin>" = {
    #   primary = true;
    #   port = "eDP-1";
    # };
    # "BNQ BenQ RD280UA HAR0021601Q" = {
    #   port = "DP-1";
    # };
    # "LG Electronics LG TV SSCR2 0x01010101" = {
    #   port = "HDMI-A-1";
    # };
  };

  networking = {
    # NOTE: conflicting with networkmanager
    # useDHCP = true;
    # interfaces.enp0s25.useDHCP = true;
    # interfaces.wlp2s0.useDHCP = true;
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
