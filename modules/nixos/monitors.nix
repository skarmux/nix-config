{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # TODO: List modelines directly? Refresh and Resolution are not fixed!
  options.monitors = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        primary = mkOption {
          type = types.bool;
          default = false;
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
          default = 60.0;
        };
        vrr = mkOption {
          type = types.bool;
          default = false;
        };
        hdr = mkOption {
          type = types.bool;
          default = false;
        };
        port = mkOption {
          type = types.str;
          example = "DP-1";
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
  };

  config = {
    /* TODO: Rewrite from listOf type to attrsOf type
    assertions = [
      {
        assertion = ((lib.length config.monitors) != 0)
        -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
    */
  };
}
