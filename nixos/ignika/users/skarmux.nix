{ self, pkgs, config, lib, ... }:
{
  home-manager.users.skarmux = {
    imports = [
      (import self.homeModules.home {
        inherit pkgs config lib self;
        username = "skarmux";
      })
      self.homeModules.git
      self.homeModules.helix
      self.homeModules.shell
      self.homeModules.desktop
      self.homeModules.security
      self.homeModules.monitoring
    ];

    home.sessionVariables = {
      # Per default, plex plants its `Library` cache dir in ~
      # TODO Does this automatically create the .local/plex dir?
      PLEX_HOME = "${config.home-manager.users.skarmux.home.homeDirectory}/.local/plex";
      EDITOR = "${pkgs.helix}/bin/hx";
    };

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

      # Media
      celluloid
      plex-media-player
      plexamp

      # Shell
      grc

      # Streaming
      obs-studio
      twitch-tui
      ffmpeg_6

      # Util
      keepassxc

      # AI
      llm # command line llm
    ];

    home.file = {
      ".ssh/id_ecdsa_sk.pub".source = "${self}/home/skarmux/id_ecdsa_sk.pub";
      ".ssh/id_ed25519.pub".source = "${self}/home/skarmux/id_ed25519.pub";
    };

    sops.defaultSopsFile = "${self}/home/skarmux/secrets.yaml";
    sops.secrets = {
      "ssh/id_ecdsa_sk" = {
        sopsFile = "${self}/home/skarmux/secrets.yaml";
        path = "/home/skarmux/.ssh/id_ecdsa_sk";
      };
    };
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
      "${self}/home/skarmux/id_ed25519.pub"  # hardware
      "${self}/home/skarmux/id_ecdsa_sk.pub" # hardware
    ];
  };
}
