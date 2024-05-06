{ config, pkgs, lib, ... }:
let
  nextcloud-server = "http://whenua/nextcloud";
  nextcloud-path = "/documents";
  nextcloud-dir = "${config.home.homeDirectory}/Nextcloud";
in
{
  sops.secrets.nextcloud = {
    sopsFile = ../../secrets.yaml;
    path = "${config.home.homeDirectory}/.netrc";
  };

  systemd.user = {

    services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud";
        After = "network-online.target"; 
      };
      Service = {
        Type = "simple";
        ExecStart= lib.concatStrings [
          "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n "
          "--path ${nextcloud-path} ${nextcloud-dir} ${nextcloud-server}"
        ]; 
        TimeoutStopSec = "180";
        KillMode = "process";
        KillSignal = "SIGINT";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };

    timers.nextcloud-autosync = {
      Unit = {
        Description = lib.concatStrings [
          "Automatic sync files with Nextcloud when booted "
          "up after 5 minutes then rerun every 60 minutes"
        ];
      };
      Timer.OnBootSec = "5min";
      Timer.OnUnitActiveSec = "60min";
      Install.WantedBy = [ "multi-user.target" "timers.target" ];
    };

    startServices = "sd-switch";
  };

}
