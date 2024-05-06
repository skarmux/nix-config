{ config, lib, ... }:
let inherit (lib) mkOption types;
in {
  options.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          example = "DP-1";
        };
        primary = mkOption {
          type = types.bool;
          default = false;
        };
        noBar = mkOption {
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
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
        };
        vrr = mkOption {
          type = types.bool;
          default = false;
        };
        hdr = mkOption {
          type = types.bool;
          default = false;
        };
        workspace = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        workspace_padding = {
          top = mkOption {
            type = types.int;
            default = 0;
          };
          bottom = mkOption {
            type = types.int;
            default = 0;
          };
          left = mkOption {
            type = types.int;
            default = 0;
          };
          right = mkOption {
            type = types.int;
            default = 0;
          };
        };
      };
    });
    default = [ ];
  };

  config = {
    # Assure only one primary monitor
    assertions = [{
      assertion = ((lib.length config.monitors) != 0)
        -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
      message = "Exactly one monitor must be set to primary.";
    }];

  };
}
