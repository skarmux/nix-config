{ config, ... }:
{
  services.protonvpn.enable = true;

  sops.secrets.deluge = {
    sopsFile = ../secrets.yaml; 
  };

  services.deluge = {
    enable = true;

    user = "deluge";
    group  = "deluge";

    web = {
      enable = false;
      port = 8112;
      openFirewall = true;
    };

    dataDir = "/var/lib/deluge";

    declarative = false;
    config = {
      download_location = "/home/skarmux/Downloads/";
      listen_interface = config.services.protonvpn.interface.name;
      outgoing_interface = config.services.protonvpn.interface.name;
      torrentfiles_location = "/home/skarmux/Downloads/";
      random_port = false;
    };
    authFile = config.sops.secrets.deluge.path;
    openFirewall = false;
  };
}
