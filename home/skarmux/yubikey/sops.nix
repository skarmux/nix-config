{ config, ... }:
{
  sops = {
    gnupg.home = "${config.gpg.homeDir}";
    defaultSopsFile = ../secrets.yaml;
  };
}
