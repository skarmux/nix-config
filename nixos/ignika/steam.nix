{ pkgs, lib, ... }:
{
  programs = {

    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [ "--mangoapp" "--hdr-enabled" "-W 3840" "-H 2560" ];
        # env = { };
      };
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          # PROTON_HIDE_NVIDIA_GPU = "0";
          # PROTON_ENABLE_NVAPI = "1";
          # VKD3D_DISABLE_EXTENSIONS = "VK_NV_low_latency2";
          # VKD3D_CONFIG = lib.concatStringsSep "," [
          #   "no_upload_hv"
          #   "force_host_cached"
          # ];
          # __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
          # LD_PRELOAD="$LD_PRELOAD:${pkgs.gamemode}/lib/libgamemode.so";
        };
      };
      extraPackages = with pkgs; [
        mangohud
        gamemode
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      # extest.enable = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true; # FIXME Can't set this to `true`. Gamescope crashes on startup.
      # args = [ "--rt" "--hdr-enabled" "--mangoapp" ];
      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        # Warning: GPU optimisations have the potential to damage hardware
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_device = 0;
        #   amd_performance_level = "high";
        # };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

  }; # programs

  home-manager.users.skarmux = {
    home.sessionVariables = {
      # PROTON_HIDE_NVIDIA_GPU = "0";
      # PROTON_ENABLE_NVAPI = "1";
      # VKD3D_DISABLE_EXTENSIONS = "VK_NV_low_latency2";
      # VKD3D_CONFIG = lib.concatStringsSep "," [
      #   "no_upload_hv"
      #   "force_host_cached"
      # ];
      # __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      # LD_PRELOAD="$LD_PRELOAD:${pkgs.gamemode}/lib/libgamemode.so";
    };
    home.file = {
      # Ensure that more than one core is used for vulkan shader processing
      ".steam/steam/steam_dev.cfg".text = ''
        unShaderBackgroundProcessingThreads 8
      '';
    };
  };
}
