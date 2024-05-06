{ pkgs, config, ... }: {
  users.users."skarmux" = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Nils Harbke";
    # Same as user `skarmux` on NAS for `nfs` rights mapping
    uid = 1026;
    extraGroups = [
      "wheel" # (sudo)
      "audio"
      "sound"
      "video"
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
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../../home/skarmux/yubikey/id_ecdsa_sk.pub)
    ];
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.skarmux-password = {
   sopsFile = ../../secrets.yaml;
   neededForUsers = true;
  };

  home-manager.users.skarmux = {
    imports = [ ../../../../home/skarmux/${config.networking.hostName}.nix ];
  };
}
