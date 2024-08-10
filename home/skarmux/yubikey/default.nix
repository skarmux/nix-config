{ pkgs, config, ... }:
{
  imports = [
    ./ssh.nix
    ./gpg.nix
    ./sops.nix
  ];

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-agent
  ];

}
