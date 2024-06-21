{ pkgs, config, ... }:
let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users."skarmux" = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Nils Harbke";
    # # Same as user `skarmux` on NAS for `nfs` rights mapping
    # uid = 1026;
    extraGroups = [
      "wheel" # (sudo)
    ]
    ++ ifTheyExist [
      "video"
      "audio"
      "network" # (access to settings)
      "i2c" # (access external devices like monitors)
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
      "adbusers"
    ];
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    packages = [ pkgs.home-manager ];
    openssh.authorizedKeys.keyFiles = [
      ../../../../home/skarmux/yubikey/id_ed25519.pub
      ../../../../home/skarmux/yubikey/id_ecdsa_sk.pub
    ];
  };

  sops.secrets.skarmux-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  services.openssh.settings.AllowUsers = ["skarmux"];

  nix.settings.trusted-users = ["skarmux"];

  # home-manager.users.skarmux = {
  #   imports = [ ../../../../home/skarmux/${config.networking.hostName}.nix ];
  # };
}
