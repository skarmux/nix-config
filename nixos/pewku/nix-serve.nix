{ config, lib, ... }:
{
  services = {

    nix-serve = {
      enable = true;
      secretKeyFile = config.sops.secrets."cache-priv-key".path;
      port = 3337;
    };
    
    # nginx = {
    #   virtualHosts."cache.skarmux.tech" = lib.mkIf config.services.nix-serve.enable {
    #     forceSSL = true;
    #     enableACME = true;
    #     locations."/" = {
    #       proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString 3337}";
    #       recommendedProxySettings = true;
    #     };
    #   };
    # };
  
  };
}
