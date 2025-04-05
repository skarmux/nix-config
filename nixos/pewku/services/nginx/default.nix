{
  services.nginx = {
    enable = true;

    # TODO: How does this play with headscale?
    # tailscaleAuth = { enable = true; };

    # recommendedTlsSettings = true;
    # recommendedZstdSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    # TODO: Setup nas as syslog server
    # appendConfig = ''
    #   error_log syslog:server=whenua;
    #   access_log syslog:server=whenua;
    # '';
  };

  sops.secrets = {
    "skarmux_tech/certificate_key".owner = "nginx";
  };
}
