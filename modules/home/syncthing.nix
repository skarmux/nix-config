{ pkgs, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.syncthing;
  device = {
    id = mkOption {
      type = types.str;
    };
    name = mkOption {
      type = types.str;
    };
    compression = mkOption {
      type = types.str;
      default = "metadata";
    };
    introducer = mkOption {
      type = types.bool;
      default = false;
    };
    skipIntroductionRemovals = mkOption {
      type = types.bool;
      default = false;
    };
    introducedBy = mkOption {
      type = types.str;
      default = "";
    };
    address = mkOption {
      type = types.enum;
      default = "dynamic";
    };
    paused = mkOption {
      type = types.bool;
      default = false;
    };
    autoAcceptFolders = mkOption {
      type = types.bool;
      default = false;
    };
    maxSendKiB = mkOption {
      type = types.int;
      default = 0;
    };
    maxRequestKiB = mkOption {
      type = types.int;
      default = 0;
    };
    untrusted = mkOption {
      type = types.bool;
      default = false;
    };
    remoteGUIPort = mkOption {
      type = types.int;
      default = 0;
    };
    numConnections = mkOption {
      type = types.int;
      default = 0;
    };
  };
in
{
  options.services.syncthing = {
    # TODO    
  };

  config = mkIf cfg.enable {
    # TODO
  };
}
