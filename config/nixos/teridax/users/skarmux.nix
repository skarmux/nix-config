{ config, ... }:
{
  users.users.skarmux = {
    isNormalUser = true;
    # shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "i2c" # control connected devices
      "networkmanager"
    ];
    hashedPasswordFile = config.sops.secrets."users/skarmux".path;
  };

  home-manager.users.skarmux = {
    imports = [
      ../../../home/base.nix
      ../../../home/desktop.nix
    ];
    home = {
      username = "skarmux";
      stateVersion = config.system.stateVersion;
    };
  };

  sops.secrets."users/skarmux".neededForUsers = true;
}