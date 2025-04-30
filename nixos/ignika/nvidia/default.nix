# https://nixos.wiki/wiki/Nvidia
# https://discourse.nixos.org/t/electron-apps-dont-open-on-nvidia-desktops/32505/4
# https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
{ config, pkgs, ... }: {
  # RTX3090 Hardware IDs
  # 10de:2204 Graphics
  # 10de:1aef Audio

  hardware.nvidia = {
    # Modesetting is required if using proprietary driver
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # use proprietary for gaming
    open = false;

    nvidiaSettings = true;

    # recommended `true` to fix tearing, but makes anything stutter badly.
    forceFullCompositionPipeline = false;

    # package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  environment.sessionVariables = {
    # Force GBM as backend
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # WLR_NO_HARDWARE_CURSORS = "1";

    # -----------------------------------------------------------------------
    # Hardware Video Acceleration
    LIBVA_DRIVER_NAME = "nvidia"; # nouveau | vdpau | nvidia
    VDPAU_DRIVER = "va_gl";

    # -----------------------------------------------------------------------
    # GLX + OpenGL

    # Refresh Rate & Flickering
    # __GL_GSYNC_ALLOWED = "1";
    # __GL_VRR_ALLOWED = "1";
    # WLR_DRM_NO_ATOMIC = "1"; # Use legacy DRM interface

    # -----------------------------------------------------------------------
    # Vulkan
    __VK_LAYER_NV_optimus = "NVIDIA_only";

    # -----------------------------------------------------------------------
    # Proton Steam
    # PROTON_HIDE_NVIDIA_GPU = "0";
    # PROTON_ENABLE_NVAPI = "1";

    # DXVK_ENABLE_NVAPI = "1";
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
