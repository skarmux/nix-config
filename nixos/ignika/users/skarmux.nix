{ pkgs, config, ... }:
{
  home-manager.users.skarmux = {
    imports = [
      # self.homeModules.brave
      # self.homeModules.keepassxc
      # self.homeModules.messenger
      # self.homeModules.code
    ];
    home = {
      username = "skarmux";
      homeDirectory = "/home/skarmux";
      stateVersion = "24.11";
      packages = with pkgs; [
        git   # versioning
        bat   # cat replacement
        fzf   # fuzzy file finder
        jq    # json parsing
        grc   # semantic coloring of stdout for non-themed output
        p7zip # 7z
        unzip # zip
        unrar # rar
      ];
    };
    systemd.user.startServices = "sd-switch";
    # Dark Mode in GNOME
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };

  users.users.skarmux = {
    isNormalUser = true;
    shell = pkgs.bash;
    # description = "Nils Harbke";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "i2c"
    ];
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    packages = with pkgs; [ home-manager ]; # Everything else in home-manager config
    # TODO Make ssh connecton 2FA
    openssh.authorizedKeys.keyFiles = [
      ./id_ed25519.pub
      ./id_ecdsa_sk.pub
    ];
  };
}

