{ config, ... }:
{
  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfSahJoIaxQ31rSXlDgm4OzdShZGFkTaGsgXsP+D1v/ pewku-deployment"
    ];
  };

  home-manager.users.skarmux = {
    imports = [
      ../../../home/base.nix
    ];
    home = {
      username = "skarmux";
      stateVersion = config.system.stateVersion;
    };
  };
}