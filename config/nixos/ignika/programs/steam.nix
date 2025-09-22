{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      args = [
        # TODO: I need two sessions for each monitor in use.
        #       Meaning different resolutions and VRR caps.
        #       Specialisation: https://nixos.wiki/wiki/Specialisation
        #       or
        #       Fetch the values from the environment depending on whether
        #       the TV is turned on or off.
        "--output-width 3840"
        "--output-height 2160"
        # My system can easily run games at native 4K *cough cough*
        "--nested-width 3840"
        "--nested-height 2160"
        "-r 119.88"
        # Run on nvidia-drm directly
        "--backend drm" # auto (default) | drm | sdl | wayland | openvr | headless
        "--hdr-enabled"
        "--hdr-itm-enabled"
        # "--mangoapp" # FIXME: Not running (visible) at all!
        "--adaptive-sync"
        # TODO: Think I need this for running Discord
        "--expose-wayland" 
        "--xwayland-count 3"
        "--force-grab-cursor"
        "--rt" # Use realtime scheduling
        # "--prefer-vk-device 10de:2204" # device id from my RTX3090
        # Embedded
        "--prefer-output HDMI-A-1"
        "--immediate-flips" # Allow tearing
      ];
      steamArgs = [
        "-steamos3"
        "-gamepadui"
        "-pipewire-dmabuf"
      ];
      env = {
        PROTON_ENABLE_HDR = "1";
        DXVK_HDR = "1";

        # TODO: Learn what these do exactly.
        VK3D_DISABLE_EXTENSIONS = "VK_NV_low_latency2";
        VK3D_CONFIG = "no_upload_hv,force_host_cached";

        # [14.10.2024] https://steamcommunity.com/app/221410/discussions/0/4700160821455702960/
        # WSI Reported better framelimiting with this enabled
        ENABLE_GAMESCOPE_WSI = "0";
        # Enable support for xwayland isolation per-game in Steam
        STEAM_MULTIPLE_XWAYLANDS = "1";
        # sdl video driver
        SDL_VIDEODRIVER = "x11";
        # hdr support in steam
        STEAM_GAMESCOPE_HDR_SUPPORTED = "1";
        # Show VRR controls in Steam
        STEAM_GAMESCOPE_VRR_SUPPORTED = "1";
        # Color management support
        STEAM_GAMESCOPE_COLOR_MANAGED = "1";
        STEAM_GAMESCOPE_VIRTUAL_WHITE = "1";
        # Scaling support
        STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
        # We have NIS support
        STEAM_GAMESCOPE_NIS_SUPPORTED = "1";
        # Support for gamescope tearing with GAMESCOPE_ALLOW_TEARING atom
        STEAM_GAMESCOPE_HAS_TEARING_SUPPORT = "1";
        # Enable tearing controls in steam
        STEAM_GAMESCOPE_TEARING_SUPPORTED = "1";
        # Enable Mangoapp
        STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
        STEAM_USE_MANGOAPP = "1";
        STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND = "1";
        # Enable horizontal mangoapp bar
        STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
        # Set input method modules for Qt/GTK that will show the Steam keyboard
        #export QT_IM_MODULE=steam
        #export GTK_IM_MODULE=Steam
        # Enable volume key management via steam for this session
        #export STEAM_ENABLE_VOLUME_HANDLER=1
        # Disable automatic audio device switching in steam, handled by wireplumber
        STEAM_DISABLE_AUDIO_DEVICE_SWITCHING = "1";
        # Force Qt applications to run under xwayland
        QT_QPA_PLATFORM = "xcb";
        # Don't wait for buffers to idle on the client side before sending them
        vk_xwayland_wait_ready = "false";
        # Some environment variables by default (taken from Deck session)
        SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
        # nv12 color fix 
        GAMESCOPE_NV12_COLORSPACE = "k_EStreamColorspace_BT601";
        # Support for gamescope tearing with GAMESCOPE_ALLOW_TEARING atom
        GAMESCOPE_ALLOW_TEARING = "1";
        # To play nice with the short term callback-based limiter for now 
        GAMESCOPE_LIMITER_FILE = "$(mktemp /tmp/gamescope-limiter.XXXXXXXX)";
        # To expose vram info from radv
        WINEDLLOVERRIDES = "dxgi=n";
        # radv stuff? requires more configuration?
        #STEAM_USE_DYNAMIC_VRS = "1";
        # Workaround older versions of vkd3d-proton
        #VKD3D_SWAPCHAIN_LATENCY_FRAMES = "3";
        # Have SteamRT's xdg-open send http:// and https:// URLs to Steam
        SRT_URLOPEN_PREFER_STEAM = "1";
        # We have the Mesa integration for the fifo-based dynamic fps-limiter
        #STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER = "1";
        # Let steam know it can unmount drives without superuser privileges
        #STEAM_ALLOW_DRIVE_UNMOUNT = "1";
        ### Tearing ###
        # Temporary crutch until dummy plane interactions / etc are figured out
        #GAMESCOPE_DISABLE_ASYNC_FLIPS = "1";
      };
    };
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [
      mangohud
      gamemode
      gamescope
      # libkrb5
      # keyutils
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    # extest.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    # env = { };
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  home-manager.users.skarmux = {
    home.file = {
      # Ensure that more than one core is used for vulkan shader processing
      # Update: Since `fossilize` running in the background is eating up RAM
      #         as well, I'm gonna reduce the thread count from 8 to 4.
      # FIXME: Deactivated since Fossilize freezes my system while filling up RAM and CPU
      # ".steam/steam/steam_dev.cfg".text = ''
      #   unShaderBackgroundProcessingThreads 4
      # '';
    };
  };
}
