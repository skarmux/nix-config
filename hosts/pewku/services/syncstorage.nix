{ pkgs, config }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.firefox-syncserver = {
    enable = true;
    database = {
      # user = user;
      host = "localhost";
    };
    secrets = config.sops.secrets."firefox-sync/env".path;
    singleNode = {
      enable = true;
      enableTLS = true;
      enableNginx = true;
      hostname = "syncstorage.skarmux.tech";
      capacity = 1;
    };
    settings = {
      port = 8000;
    };
  };

  sops.secrets = {
    "firefox-sync/env" = {
      # owner = user;
      # group = user;
      sopsFile = ../secrets.yaml;
      neededForUsers = true;
    };
  };
}
