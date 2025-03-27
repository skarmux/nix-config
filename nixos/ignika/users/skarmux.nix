{ self, pkgs, config, lib, ... }:
{
  home-manager.users.skarmux = {
    imports = [
      (import self.homeModules.home {
        inherit pkgs config lib self;
        username = "skarmux";
      })
    ];

    home.packages = with pkgs; [
      # Browser
      brave

      # Messenger
      discord
      element-desktop
      signal-desktop
      telegram-desktop

      # Games
      steam

      # Video
      celluloid

      # Shell
      grc

      # Streaming
      obs-studio
      twitch-tui
      ffmpeg_6

      # Util
      keepassxc
    ];
  };

  users.users.skarmux = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "i2c"
    ];
    hashedPasswordFile = config.sops.secrets.skarmux-password.path;
    openssh.authorizedKeys.keyFiles = [
      ./id_ed25519.pub
      ./id_ecdsa_sk.pub
    ];
  };
}
