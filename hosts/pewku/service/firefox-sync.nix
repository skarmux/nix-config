{ config
, port ? 8000 
, ...
}:
{
  # hosts/pewku/secrets.yaml
  sops.secrets = {
    "firefox-sync/env" = {
      sopsFile = ../secrets.yaml;
    };
  };

  services.firefox-syncserver = {
    enable = true;
    database = {
      host = "localhost"; # runs locally
    };
    secrets = config.sops.secrets."firefox-sync/env".path;
    singleNode = {
      enable = true;
      enableTLS = false;
      enableNginx = false; # already accessible via tailnet0 interface
      # TODO: make sure the hostname is the one given by
      #       tailscale MagicDNS
      hostname = config.networking.hostName;
      capacity = 1;
    };
    settings = {
      port = port;
    };
  };

  # TODO: make assertion that tailscale is configured
}
