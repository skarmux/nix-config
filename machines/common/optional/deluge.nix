{ config
, port ? 8112
, ... }:
{
  # hosts/common/secrets.yaml
  sops.secrets.deluge = {
    sopsFile = ../secrets.yaml; 
  };

  services =  {

    protonvpn.enable = true;
    
    deluge = {
      enable = true;

      user = "deluge";
      group  = "deluge";

      web = {
        enable = true;
        port = port;
        openFirewall = false;
      };

      dataDir = "/var/lib/deluge/data";

      declarative = false;
      config = {
        download_location = "/var/lib/deluge/downloads";
        listen_interface = config.services.protonvpn.interface.name;
        outgoing_interface = config.services.protonvpn.interface.name;
        torrentfiles_location = "/var/lib/deluge/torrents";
        random_port = false;
      };
      authFile = config.sops.secrets.deluge.path;
      openFirewall = false;
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [ "/var/lib/deluge" ];
  };

}
