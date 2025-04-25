{ config, ... }:
{
  # Home

  home-manager.users.skarmux = {
    imports = [ ../../../home/skarmux/home.nix ];

    # services.syncthing = {
    #   enable = true;
    #   # https://docs.syncthing.net/users/syncthing.html
    #   extraOptions = [
    #     "--gui-address=https://127.0.0.1:8384"
    #     "--no-default-folder" # Don't create ~/Sync
    #   ];
    # };
  };

  # NixOS

  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [ "wheel" "i2c" ]; # TODO `i2c` for what? Fan control?
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;

    # To keep the syncthing user service active 24/7
    # NOTE: This is a small security risk!
    # linger = true;

    openssh.authorizedKeys.keys = [
      # Access only with hardware keys. No exceptions!
      (builtins.readFile ../../../keys/id_yc.pub)
      (builtins.readFile ../../../keys/id_ya.pub)
    ];
  };

  sops.secrets = {
    "skarmux-password".neededForUsers = true;
  };
}
