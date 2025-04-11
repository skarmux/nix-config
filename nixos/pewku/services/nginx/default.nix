{
  services.nginx = {
    enable = true;

    # TODO: How does this play with headscale?
    # tailscaleAuth.enable = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    # recommendedZstdSettings = true;

    # TODO: Setup nas as syslog server
    # appendConfig = ''
    #   error_log syslog:server=whenua;
    #   access_log syslog:server=whenua;
    # '';
    
    # virtualHosts = {
    #   "skarmux.tech" = {
    #     onlySSL = true; # TODO: Is 'forceSSL' better?
    #     sslCertificate = ./ssl/skarmux_tech/ssl-bundle.crt;
    #     sslTrustedCertificate = ./ssl/skarmux_tech/SectigoRSADomainValidationSecureServerCA.crt;
    #     sslCertificateKey = config.sops.secrets."skarmux_tech/certificate_key".path;
    #   };
    # };
  };

  # sops.secrets = {
  #   "skarmux_tech/certificate_key".owner = "nginx";
  # };
}
