# [Configure Exit Nodes]
# On the client:
# sudo tailscale set --advertise-exit-node
#
# On the control server:
# sudo headscale routes enable -r <ID>
#
{ config
, port ? 8085
, portForMetrics ? 8095
, domain ? "tailscale.skarmux.tech"
, ...
}:
{
  services = {
    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = port;
      settings = {
        server_url = "https://${domain}";
        metrics_listen_addr = "127.0.0.1:${toString portForMetrics}";
        logtail.enabled = false;
        log.level = "warn";
        ip_prefixes = [
          "100.69.0.0/24"
          "fd7a:115c:a1e0:69::/64"
        ];
      };
    };

    nginx.virtualHosts = {
      "tailscale.skarmux.tech" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString port}";
            proxyWebsockets = true;
          };
          "/metrics" = {
            proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
          };
        };
      };
    };
  };

  # environment.persistence = {
  #   "/nix/persist".directories = [
  #     "/var/lib/headscale"
  #   ];
  # };
}
