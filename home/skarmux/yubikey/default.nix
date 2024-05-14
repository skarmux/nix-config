{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-agent
  ];
}
