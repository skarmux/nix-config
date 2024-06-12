{ inputs, pkgs, ... }:
let
  domain = "feaston.skarmux.tech";
  port = 5000;
  databaseURL = "/home/feaston/db.sqlite?mode=rwc";
in
{
  users.users.feaston = {
    isNormalUser = true;
    password = "";
    linger = true;
    openssh.authorizedKeys.keyFiles = [
      ../../../home/skarmux/yubikey/id_ed25519.pub
      ../../../home/skarmux/yubikey/id_ecdsa_sk.pub
    ];
  };

  security.pam.loginLimits = [{
    domain = "${domain}";
    type = "soft";
    item = "nofile";
    value = "2048";
  }];

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@skarmux.tech";
  };

  # users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
      upstreams."feaston-api" = {
        # extraConfig = ''
        # keepalive 2 ;
        # zone upstreams 64K ;
        # '';
        servers."127.0.0.1:${toString port}" = {
          max_fails = 1;
          fail_timeout = "2s";
        };
      };
      virtualHosts = {
        "${domain}" = {
          forceSSL = true;
          enableACME = true;
          root = "${inputs.feaston.packages.${pkgs.system}.default}/www";
          # extraConfig = ''
          #   worker_connections = 1024 ;
          # '';
          locations."/" = {
            tryFiles = "$uri $uri/ =404";
            extraConfig = ''
              add_header Cache-Control "public, max-age=31536000" ;
            '';
          };
          locations."/api/" = {
            proxyPass = "http://feaston-api/";
            extraConfig = ''
              proxy_next_upstream error timeout http_500 ;
            '';
          };
        };
      };
  };

  home-manager.users.feaston = {
    systemd.user = {
      startServices = "sd-switch";
      services."feaston" = {
        Unit = {
          Description = "Serve Feast-On web service.";
          StartLimitIntervalSec = 30;
          StartLimitBurst = 2;
        };
        Service = {
          ExecStart = "${inputs.feaston.packages.${pkgs.system}.default}/bin/feaston --database-url ${databaseURL} --port ${toString port}";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
    home.stateVersion = "24.05";
  };

  nix.settings.trusted-users = [ "feaston" ];
  services.openssh.settings.AllowUsers = [ "feaston" ];
}
