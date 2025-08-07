{ pkgs, config, ... }:
let
  #description: @@@ Default
  #make: @@@
  #model: Default
  #serial:
in
{
  
  /*
  home-manager.users.skarmux = {
    wayland.windowManager.hyprland = {
      settings = {
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          # Custom EDID only works on port name
          "${port},3840x2160@120,3840x0,1,vrr,3"
        ];
      };
    };
  };
  */

  monitors.lgcx = {
    desc = "LG Electronics LG TV SSCR2 0x01010101";
    width = 3840;
    height = 2160;
    refresh = 119.98;
    vrr = true;
    hdr = true;
  };

  # In order for gamescope to choose the correct video mode from the CVT-8XX extension block of
  # the EDID sent from my LG TV, I read the EDID binary from /sys/class/drm/card0-HDMI-A-1/edid,
  # opened it with CRU (Custom Resolution Utility) and removed every resolution other than the
  # 4K@120 from within the extension block TV-resolutions.
  #
  # Since the EDID for this exact TV found in `linuxhw` also lists VRR capabilities, I manually
  # enabled those as well in CRU with the range of 40-120hz.
  # (Appears to be working, although I sense stuttering. TODO: Needs some more research.)
  #
  # I exported the modified EDID binary and converted it to the base64 you're seeing below.
  #
  # TODO: Setting the required resolution and framerate via custom modeline might work still,
  #       but I'm not sure whether this approach forces that modeline or just adds it to the
  #       ones from the EDID.
  # TODO: Can't use the same value for `desc:` in hyprland, cause that's changed in the custom
  #       EDID. Gotta do it again and keep it more to the original.
  hardware.display = let 
    edid_bin = "LG_TV_SSCR2.bin";
  in {

    edid = {
      enable = true;
      # List of packages containing EDID binary files at `$out/lib/firmware/edid`. Such files
      # will be available for use in `drm.edid_firmware` kernel parameter as `edid/<filename>`.
      # You can craft one directly here or use sibling options `linuxhw` and `modelines`.
      packages = [
        (pkgs.runCommand "edid-custom" {} ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/${edid_bin}" <<EOF
          AP///////wAAAAAAAAAAAAAAAQSgQCQABwAAAAAAAAAAAAAhCAABAQEBAQEBAQEBAQEBAQEBAAAA
          /QAYeB7/dwEKICAgICAgAAAA/ABEZWZhdWx0CiAgICAgAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAA
          AAAAAAAAAAAAAAAAAUUCA0pgQXYsCVcHFQdQVwcBZwQDbgMMADAAuDwkAIABAgMEbdhdxAF4gFMA
          KHiBAADiAM/jBYAA4wYNAeIP/+sBRtAASAN2imZyfAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACw==
          EOF
        '')
      ];
      linuxhw = {
        # LG_TV_SSCR2_2020 = [ "Goldstar" "GSMC0C8" "LG TV SSCR2" "2020" "3840x2160" ];
      };
      modelines = {
        # NOTE: Skip first column with label.
        # "LG_TV_SSCR2" = "   119.88 3840 4016 4104 4400 2160 2168 2178 2250 +hsync +vsync";
        #                   (clk)  |x-resolution     | |y-resolution     |
        #                          |hsyncstart       | |vsyncstart       |
        #                          |hsyncend         | |vsyncend         |
        #                          |htotal           | |vtotal
      };
    };

    # A `video` kernel parameter (framebuffer mode) configuration for the specific output:
    # `<xres>x<yres>[M][R][-<bpp>][@<refresh>][i][m][eDd]`
    # <xres>: The horizontal resolution in pixels.
    # <yres>: The vertical resolution in pixels.
    # [M]: Enables the use of VESA Coordinated Video Timings (CVT) to calculate the video mode timings instead of looking up the mode from a database
    # [R]: Enables reduced blanking calculations for digital displays when using CVT. This reduces the horizontal and vertical blanking intervals to save bandwidth.
    # [-<bpp>]: Specifies the color depth or bits per pixel (e.g., -24 for 24-bit color).
    # [@<refresh>]: Specifies the refresh rate in Hz.
    # [i]: Enables interlaced mode.
    # [m]: Adds margins to the CVT calculation (1.8% of xres rounded down to 8 pixels and 1.8% of yres)
    # [e]: output forced to on
    # [D]: digital output forced to on (e.g. DVI-I connector)
    # [d]: output forced to off
    outputs = {
      "${config.monitors.lgcx.port}" = {
        edid = edid_bin;
        mode = "3840x2160@120";
      };
    };
  };
}