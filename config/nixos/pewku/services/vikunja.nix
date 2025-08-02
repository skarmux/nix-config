{ config, ... }:
{
    services = {
      vikunja = {
        enable = true;
        port = 3456;
        frontendScheme = "http";
        frontendHostname = "projects.skarmux.tech";
      };
      nginx = {
        enable = true;
        virtualHosts."projects.skarmux.tech" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vikunja.port}/";
            recommendedProxySettings = true;
          };
        };
      };
    };
}