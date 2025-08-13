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
    openssh.authorizedKeys.keys = [
      (builtins.readFile config.yubico.keys."25390376".ssh.public)
      (builtins.readFile config.yubico.keys."32885183".ssh.public)
    ];
  };

  home-manager.users.skarmux = {
    imports = [
      ../../../home/base.nix
      ../../../home/desktop.nix
      ../../../home/work.nix
    ];
    home = {
      username = "skarmux";
      stateVersion = config.system.stateVersion;
    };
  };

  sops.secrets."users/skarmux".neededForUsers = true;
}