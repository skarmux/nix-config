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
      "gamemode"
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
      file.".ssh/id_ed25519.pub" = {
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfSahJoIaxQ31rSXlDgm4OzdShZGFkTaGsgXsP+D1v/ pewku-deployment";
      };
    };
  };

  sops.secrets = {
    "users/skarmux".neededForUsers = true;
    # NOTE: I need a separate key for using `deploy-rs` for deployments
    #       on pewku, since `deploy-rs` does not play with the pinentry
    #       required by ssh authentication via yubikey.
    # FIXME: Replace with a password protected SSH key.
    "pewku-deployment" = {
      path = "/home/skarmux/.ssh/id_ed25519";
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };
  };
}