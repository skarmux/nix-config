{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ausweisapp
  ];

  networking.firewall.allowedUDPPorts = [ 24727 ];
}