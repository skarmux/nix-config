# https://nixos.wiki/wiki/Nvidia
# https://discourse.nixos.org/t/electron-apps-dont-open-on-nvidia-desktops/32505/4
# https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
{ config, pkgs, ... }:
let
  # https://github.com/NixOS/nixpkgs/issues/412299#issuecomment-2955980698
  gpl_symbols_linux_615_patch = pkgs.fetchpatch {
    url = "https://github.com/CachyOS/kernel-patches/raw/914aea4298e3744beddad09f3d2773d71839b182/6.15/misc/nvidia/0003-Workaround-nv_vm_flags_-calling-GPL-only-code.patch";
    hash = "sha256-YOTAvONchPPSVDP9eJ9236pAPtxYK5nAePNtm2dlvb4=";
    stripLen = 1;
    extraPrefix = "kernel/";
  };
in
{
  # RTX3090 Hardware IDs
  # 10de:2204 Graphics
  # 10de:1aef Audio

  # IOMMU Group 17
  # 02:08.0 PCI Bridge (DO NOT USE FOR VM!)
  # 06:00.0 Non Essential
  # 06:00.1 USB Controller [1022:149c]
  # 06:00.3 USB Controller [1022:149c]
  # IOMMU Group 21
  # 04:00.0 Intel WiFi
  # IOMMU Group 23
  # 09:00.0 VGA [0300] [10de:2204] <--
  # 09:00.1 AUDIO [0403] [10de:1aef] <--
  # IOMMU Group 27
  # 0b:00.3 USB Controller [1022:149c]
  # IOMMU Group 28
  # 0b:00.4 HD Audio [1022:1487]
  #
  # AMD CPU : IOMMU, NX MODE, SVM MODE

  # Load nvidia driver into initial ramdisk
  # NOTE: Might be nice when playing with custom boot animations
  # boot.initrd.kernelModules = [
  #   "nvidia"
  #   "nvidia_modeset"
  #   "nvidia_uvm"
  #   "nvidia-drm"
  # ];

  hardware.nvidia = {
    # Modesetting is required if using proprietary driver
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # NOTE: Requires offload to be enabled
    powerManagement.finegrained = false;

    # recommended for turing/ampere or newer cards
    open = true;

    # install nvidia settings app
    nvidiaSettings = true;

    # recommended `true` to fix tearing, but makes anything stutter badly.
    forceFullCompositionPipeline = false;

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.57.08";
      openSha256 = "sha256-DOJw73sjhQoy+5R0GHGnUddE6xaXb/z/Ihq3BKBf+lg=";
      sha256_64bit = "sha256-KqcB2sGAp7IKbleMzNkB3tjUTlfWBYDwj50o3R//xvI=";
      settingsSha256 = "sha256-AIeeDXFEo9VEKCgXnY3QvrW5iWZeIVg4LBCeRtMs5Io=";
      persistencedSha256 = "sha256-Len7Va4HYp5r3wMpAhL4VsPu5S0JOshPFywbO7vYnGo=";
      usePersistenced = true;
      patches = [ gpl_symbols_linux_615_patch ];
    };
  };

  environment.sessionVariables = {
    # Selects the GBM (Generic Buffer Management) backend library
    GBM_BACKEND = "nvidia-drm";
    # Forces the GLX implementation
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # nvidia VRR support
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    # nvidia low latency 
    __GL_MaxFramesAllowed = "1";
    # nvidia TODO
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    # Vulkan apps use this for correct GPU selection
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    # Hardware Video Acceleration
    LIBVA_DRIVER_NAME = "nvidia"; # nouveau | vdpau | nvidia
    VDPAU_DRIVER = "va_gl";
    # Use all of the nvidia features in Proton
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NVAPI = "1";
  };

  environment.systemPackages = with pkgs; [
    libva # VA-API (Video Acceleration API)
    vulkan-tools
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # NVIDIA doesn't support libvdpau, so this package will redirect VDPAU calls to LIBVA.
    extraPackages = [ pkgs.libvdpau-va-gl ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
}
