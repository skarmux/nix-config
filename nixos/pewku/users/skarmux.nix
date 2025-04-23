{ self, inputs, pkgs, config, lib, ... }:
{
  imports = [ ./syncthing.nix ];

  # Home

  home-manager.users.skarmux = {
    imports = [ ../../../home/skarmux/home.nix ];
  };

  # NixOS

  users.users.skarmux = {
    isNormalUser = true;
    extraGroups = [ "wheel" "i2c" ]; # TODO `i2c` for what? Fan control?
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    
    openssh.authorizedKeys.keys = [
      # Access only with hardware keys. No exceptions!
      (builtins.readFile ../../../home/skarmux/id_yc.pub)
      (builtins.readFile ../../../home/skarmux/id_ya.pub)
    ];
  };

  sops.secrets = {
    "skarmux-password".neededForUsers = true;
  };
}
