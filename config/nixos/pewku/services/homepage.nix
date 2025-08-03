{
  services = {

    homepage = {
      enable = true;
      domain = "skarmux.tech";
    };

    nginx = {
      enable = true;
      virtualHosts."skarmux.tech" = {
        # forceSSL: Redirect HTTP to HTTPS; onlySSL: ignore HTTP entirely
        forceSSL = true;
        enableACME = true;
      };
    };
    
  };
}