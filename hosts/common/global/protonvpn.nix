{ config, ... }: {

  sops.secrets.protonvpn = {
    sopsFile = ../secrets.yaml;
  };

  services.protonvpn = {
    autostart = true;
    interface = {
      dns.enable = true;
      privateKeyFile = config.sops.secrets.protonvpn.path;
    };
    endpoint = {
      publicKey = "9+CorlxrTsQR7qjIOVKsEkk8Z7UUS5WT3R1ccF7a0ic=";
      ip = "194.126.177.14";
    };
  };

}
