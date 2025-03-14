{ inputs
, domain ? "feaston.skarmux.texh"
, port ? 6000
, ... }: 
{
  imports = [ inputs.feaston.nixosModules.default ];

  services.feaston = {
    enable = true;
    domain = domain;
    port = port;
    enableNginx = true;
    enableTLS = true;
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib/feaston" ];
  };
}
