{ self, inputs, pkgs, config, lib, ... }:
{
  # Home

  home-manager.users.skarmux = {
    services.syncthing = {
      enable = true;
      # https://docs.syncthing.net/users/syncthing.html
      extraOptions = [
        "--gui-address=https://127.0.0.1:8384"
        "--no-default-folder" # Don't create ~/Sync
      ];
    };
  };

  # NixOS

  # To keep the syncthing user service active 24/7
  # NOTE: This is a small security risk!
  users.users.skarmux.linger = true;
}
