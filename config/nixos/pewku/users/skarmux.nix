{ config, ... }:
{
  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # Login via SSH using yubikey (imported from .common)
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