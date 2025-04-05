{ inputs , ... }:
{
  imports = [ inputs.feaston.nixosModules.default ];

  services.feaston = {
    enable = true;
    domain = "feaston.skarmux.tech";
    port = 6000;
    enableNginx = true;
    enableTLS = true;
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib/feaston" ];
  };
}
