{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  environment.persistence = {
    "/nix/persist".directories = [ "/var/lib/tailscale" ];
  };

  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
  };

  # Using MagicDNS
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "taile8020.ts.net" ];

  # Required for NFS
  # services.rpcbind.enable = true;
  #
  # boot.supportedFilesystems = [ "nfs" ];

  # systemd.mounts = [
  #   {
  #     what = "${whenua_ip}:/volume1/photos";
  #     where = "/media/photos";
  #     type = "nfs";
  #     mountConfig.Options = [
  #       "noatime"
  #       "rw"
  #       "users"
  #       "vers=4"
  #       "minorversion=1"
  #       "x-systemd.automount"
  #       "noauto"
  #       "nofail"
  #     ];
  #   }
  #   {
  #     what = "${whenua_ip}:/volume1/games";
  #     where = "/media/games";
  #     type = "nfs";
  #     mountConfig.Options = [
  #       "noatime"
  #       "rw"
  #       "users"
  #       "vers=4"
  #       "minorversion=1"
  #       "x-systemd.automount"
  #       "noauto"
  #       "nofail"
  #     ];
  #   }
  #   {
  #     what = "${whenua_ip}:/volume1/plex";
  #     where = "/media/plex";
  #     type = "nfs";
  #     mountConfig.Options = [
  #       "noatime"
  #       "rw"
  #       "users"
  #       "vers=4"
  #       "minorversion=1"
  #       "x-systemd.automount"
  #       "noauto"
  #       "nofail"
  #     ];
  #   }
  # ];

  # systemd.automounts = [
  #   {
  #     where = "/media/photos";
  #     wantedBy = [ "multi-user.target" ];
  #     automountConfig = { TimeoutIdleSec = "600"; };
  #   }
  #   {
  #     where = "/media/games";
  #     wantedBy = [ "multi-user.target" ];
  #     automountConfig = { TimeoutIdleSec = "600"; };
  #   }
  #   {
  #     where = "/media/plex";
  #     wantedBy = [ "multi-user.target" ];
  #     automountConfig = { TimeoutIdleSec = "600"; };
  #   }
  # ];
}
