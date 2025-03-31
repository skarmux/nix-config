{ port ? 3456, domain ? "vikunja.skarmux.tech", ... }:
{
  services = {
    vikunja = {
      enable = true;
      port = port;
      frontendScheme = "http";
      frontendHostname = domain;
      settings = {
        timezone = "UTC";
      };
    };

    nginx.virtualHosts = {
      "${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
