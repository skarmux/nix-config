{ pkgs, config, ... }:
let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users."skarmux" = {
    isNormalUser = true;
    shell = pkgs.bash;
    description = "Nils Harbke";

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
      ../../../../home/skarmux/takua/id_ed25519.pub
      ../../../../home/skarmux/wsl/id_rsa.pub
    ];
  };

  sops.secrets.skarmux-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  services.openssh.settings.AllowUsers = ["skarmux"];

  nix.settings.trusted-users = ["skarmux"];

  home-manager.users.skarmux = {
    imports = [ ../../../../home/skarmux/${config.networking.hostName}.nix ];
  };
}
