{ pkgs, config, ... }:
{
  imports = [
    ./ssh.nix
    ./gnupg.nix
  ];

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-agent
  ];

  programs.gpg.publicKeys = [{
    source = ./public.gpg;
    trust = 5;
  }];

  sops = {
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    defaultSopsFile = ../secrets.yaml;
  };
}
