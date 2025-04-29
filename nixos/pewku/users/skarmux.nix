{ config, ... }:
{
  # Home

  # home-manager.users.skarmux = {
    # imports = [ ../../../home/skarmux/home.nix ];

    # home = {
    #   username = "skarmux";
    #   homeDirectory = "/home/skarmux";
    #   stateVersion = "24.11";
    # };

    # services.syncthing = {
    #   enable = true;
    #   # https://docs.syncthing.net/users/syncthing.html
    #   extraOptions = [
    #     "--gui-address=https://127.0.0.1:8384"
    #     "--no-default-folder" # Don't create ~/Sync
    #   ];
    # };
  # };

  # NixOS

  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [ "wheel" /* "i2c" */ ]; # TODO `i2c` for what? Fan control?

    # NOTE: Only way for login should be SSH!!
    # hashedPasswordFile = config.sops.secrets.skarmux-password.path;

    # To keep the syncthing user service active 24/7
    # NOTE: This is a small security risk!
    # linger = true;

    openssh.authorizedKeys.keys = [
      # Access only with hardware keys. No exceptions!
      (builtins.readFile ../../../keys/id_yc.pub)
      (builtins.readFile ../../../keys/id_ya.pub)
    ];
  };

  # environment.persistence."/persist" = {
  #   users.skarmux = {
  #     directories = [ ];
  #     files = [
  #       # FIXME Place into sops... Oh, wait, but it is used BY sops...
  #       #       Need to rethink attack vectors there.
  #       ".config/sops/age/keys.txt"
  #     ];
  #   };
  # };

  # sops.secrets = {
  #   "skarmux-password".neededForUsers = true;
  # };
}
