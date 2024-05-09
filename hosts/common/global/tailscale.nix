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
  # TODO: Use proton vpn
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "taile8020.ts.net" ];

}
