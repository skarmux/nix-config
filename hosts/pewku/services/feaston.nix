{ inputs, pkgs, ... }:
let
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

  services.nginx = {
      enable = true;
      virtualHosts = {
          "feaston.ddns.net" = {
              root = "${inputs.feaston.packages.${pkgs.system}.default}/www";
              locations."/" = {
                tryFiles = "$uri $uri/ /index.html";
              };
              locations."~\.css" = {
                extraConfig = ''
                  add_header Content-Type text/css ;
                '';
              };
              locations."~\.js" = {
                extraConfig = ''
                  add_header Content-Type application/x-javascript ;
                '';
              };
              locations."/api/" = {
                proxyPass = "http://127.0.0.1:${toString port}/";
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
        };
        Service = {
          ExecStart = "${inputs.feaston.packages.${pkgs.system}.default}/bin/feaston --database-url ${databaseURL} --port ${toString port}";
          Restart = "always";
        };
        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };
    };
    home.stateVersion = "24.05";
  };

  nix.settings.trusted-users = [ "feaston" ];
  services.openssh.settings.AllowUsers = [ "feaston" ];
}
