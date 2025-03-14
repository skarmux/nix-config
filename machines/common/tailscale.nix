{ lib
, config
, ...
}:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    # TODO: extraUpFlag not working for 'tailscale login' command
    extraUpFlags = ["--login-server https://tailscale.skarmux.tech"];
  };

  networking = {
    firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };

    # Using MagicDNS
    # TODO: Use proton vpn?
    nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
    search = [ "taile8020.ts.net" ];
  };

  environment.persistence."/nix/persist" = {
    directories = ["/var/lib/tailscale"];
  };
}
