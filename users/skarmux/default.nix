{ pkgs, config, ... }:
let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users."skarmux" = {
    isNormalUser = true;
    shell = pkgs.bash; # Enabled by default
    description = "Nils Harbke";
    extraGroups = [
      "wheel"
      "users"
    ]
    ++ ifTheyExist [
      "video"
      "audio"
      "network" # access to settings
      "i2c" # access external devices like monitors
      "plugdev"
      "docker"
      "git"
      "podman"
      "deluge"
      # Virtualisation
      "libvirtd"
      "kvm"
      "input"
      # Android
      # "adbusers"
    ];
    # TODO: Enforce that sops is configured
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    packages = with pkgs; [ home-manager ]; # Everything else in home-manager config
    openssh.authorizedKeys.keyFiles = [
      ./yubikey/id_ed25519.pub
      ./yubikey/id_ecdsa_sk.pub
    ];
  };

  sops.secrets.skarmux-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users."skarmux".imports = [ ./home.nix ];
}
