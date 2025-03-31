{
  config 
, port ? 3337
, domain ? "cache.skarmux.tech"
, ...
}:
{
  # hosts/pewku/secrets.yaml
  sops.secrets = {
    "cache-priv-key" = {
      sopsFile = ../secrets.yaml; 
    };
  };

  services = {

    nix-serve = {
      enable = true;
      secretKeyFile = config.sops.secrets."cache-priv-key".path;
      port = port;
    };
    
    nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString port}";
          recommendedProxySettings = true;
        };
      };
    };
  
  };
}
