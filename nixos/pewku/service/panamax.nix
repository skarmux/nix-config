{
  users.users.panamax = {
    isNormalUser = true;
    password = "";
    linger = true;
    openssh.authorizedKeys.keyFiles = [
      ../../../home/skarmux/yubikey/id_ed25519.pub
      ../../../home/skarmux/yubikey/id_ecdsa_sk.pub
    ];
  };

  # TODO: do not need home-manager
  # home-manager.users.panamax = {
  #   home = {
  #     stateVersion = "24.11";
  #     packages = [ pkgs.panamax ];
  #   };
  #   # TODO: system service run with system user is fine
  #   systemd.user = {
  #     startServices = "sd-switch";
  #     services."panamax-sync" = {
  #       Unit = {
  #         Description = "Synchronize crates.io mirror with latest crates";
  #         Wants = "panamax-sync.timer";
  #       };
  #       Service = {
  #         Type = "onehsot";
  #         ExecStart = "${pkgs.panamax}/bin/panamax sync ${config.home-manager.users.panamax.home.homeDirectory}/mirror";
  #       };
  #       Install = {
  #         WantedBy = [ "multi-user.target" ];
  #       };
  #     };
  #     timers."panamax-sync" = {
  #       Unit = {
  #         Description = "Synchronize crates.io mirror with latest crates";
  #         Requires = "panamax-sync.service";
  #       };
  #       Timer = {
  #         Unit = "panamax-sync.service";
  #         OnCalendar = "*-*-* 01:00:00";
  #       };
  #       Install = {
  #         WantedBy = [ "timers.target" ];
  #       };
  #     };
  #   };
  # };

  services.nginx = {
    enable = true;
    # virtualHosts = {
    #   "panamax.internal" = {
    #     listen = [ "80" "[::]:80" ];
    #     root = "${config.home.homeDirectory}/mirror";
    #     locations."/" = {
    #       extraConfig = ''
    #         autoindex on;
    #       '';
    #     };
    #     locations."~ /crates.io-index(/*)" = {
    #       extraConfig = ''
    #         fastcgi_param GIT_PROJECT_ROOT ${config.homeDirectory}/mirror/crates.io-index;
    #         include fastcgi_params;
    #         fastcgi_pass unix:/var/run/fcgiwrap.socket;
    #         fastcgi_param SCRIPT_FILENAME /usr/lib/git-core/git-http-backend;
    #         fastcgi_param GIT_HTTP_EXPORT_ALL "";
    #         fastcgi_param PATH_INFO $1;
    #       '';
    #     };
    #     extraConfig = ''
    #       # Rewrite the download URLs to match the proper crates location.
    #       rewrite "^/crates/([^/])/([^/]+)$"                     "/crates/1/$1/$2"         last;
    #       rewrite "^/crates/([^/]{2})/([^/]+)$"                  "/crates/2/$1/$2"         last;
    #       rewrite "^/crates/([^/])([^/]{2})/([^/]+)$"            "/crates/3/$1/$1$2/$3"    last;
    #       rewrite "^/crates/([^/]{2})([^/]{2})([^/]*)/([^/]+)$"  "/crates/$1/$2/$1$2$3/$4" last;
    #     ''; 
    #   };
    # };
  };
}
