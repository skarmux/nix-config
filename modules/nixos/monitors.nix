{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.monitors;
in
{
  # TODO: List modelines directly? Refresh and Resolution are not fixed!
  # TODO: I want to be able to access the primary monitor with config.monitors.primary
  options.monitors = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        primary = mkOption {
          type = types.bool;
          default = false;
          description = ''
            The main or "center" monitor. Make sure it's one that is permanently plugged in.
          '';
        };
        desc = mkOption {
          type = types.str;
          default = "";
          example = "LG Electronics LG TV SSCR2 0x01010101";
          description = ''
            The `desc:` attribute from `hyprctl monitors`. Commonly a
            combination of `make:`, `model:` and `serial:`.
          '';
        };
        port = mkOption {
          type = types.str;
          example = "DP-1";
          description = ''
            Physical port reported by GDM (graphics driver) where the
            monitor is plugged in.
          '';
        };
        width = mkOption {
          type = types.int;
          example = 1920;
        };
        height = mkOption {
          type = types.int;
          example = 1080;
        };
        refresh = mkOption {
          type = types.float;
          example = 59.998;
        };
        vrr = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Capable of variable refresh rate or adaptive sync.
            Also part of the HDMI 2.1 specification.
          '';
        };
        hdr = mkOption {
          type = types.bool;
          default = false;
          description = ''
            HDR capable display with 10bit color support.
          '';
        };
        /* TODO: wip
        modes = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = ''
            Specify available modes that can be used by the system.
          '';
          example = [ "3840x2160@120" ];
        };
        */
      };
    });
    default = { };
    description = "Monitor configuration.";
  };

  config = let
    monitorNames = builtins.attrNames cfg;
  in {
    assertions = [
      {
        assertion =
          ((lib.length monitorNames) != 0)
          ->
          ((lib.length (lib.filter (name: config.monitors.${name}.primary) monitorNames)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];

    # hardware.display.edid = {
    #   packages
    #   modelines
    #   linuxhw
    #   enable
    # };

    # hardware.display.outputs = {
    #   config.monitors.<name>.port = {
    #     mode = ;
    #     edid = ;
    #   };
    # };

  };
}
