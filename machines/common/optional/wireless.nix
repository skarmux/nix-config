{ config, ... }: {
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {

    enable = true;

    fallbackToWPA2 = false;

    # TODO had to be removed. substitute properly!
    # environmentFile = config.sops.secrets.wireless.path;

    networks = { "@home_ssid@" = { psk = "@home_psk@"; }; };

    # Allow user group to control WiFi settings 
    userControlled = {
      enable = true;
      group = "network";
    };

  };

  # Ensure group exists
  users.groups."network" = { };

  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
