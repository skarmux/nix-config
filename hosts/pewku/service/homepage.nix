{ inputs
, domain ? "skarmux.tech"
, ... }: 
{
  imports = [ inputs.homepage.nixosModules.default ];

  services.homepage = {
    enable = true;
    domain = domain;
  };
}
