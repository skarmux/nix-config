{ config }:
{
  sops.secrets = {
    "skarmux_tech/certificate_key" = {
      owner = "nginx";
      sopsFile = ./secrets.yaml; 
    };
  };

  services.nginx = {
    virtualHosts = {
      "skarmux.tech" = {
        onlySSL = true; # TODO: Is 'forceSSL' better?
        sslCertificate = ./nginx/ssl/skarmux_tech/ssl-bundle.crt;
        sslTrustedCertificate = ./nginx/ssl/skarmux_tech/SectigoRSADomainValidationSecureServerCA.crt;
        sslCertificateKey = config.sops.secrets."skarmux_tech/certificate_key".path;

        locations."/" = {
            # TODO: My personal landing page. :3
            return =404;
          };
        };
      };
    };
  }
