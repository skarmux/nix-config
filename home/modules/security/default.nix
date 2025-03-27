{ pkgs, config, ... }:
{
  imports = [
    ./sops.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-agent
  ];
}
