{ pkgs, ... }:
{
    networking.firewall.allowedTCPPorts = [ 5432 ];

    services.postgresql = {
      enable = true;

      # settings = { port = 5432; };

      package = pkgs.postgresql_17;

      initialScript = pkgs.writeText "backend-initScript" ''
        GRANT ALL PRIVILEGES ON DATABASE sjc_dev TO skarmux;
        GRANT ALL PRIVILEGES ON SCHEMA public TO skarmux;
      '';

      ensureUsers = [
        { name = "skarmux"; }
        { name = "sjc"; }
      ];

      ensureDatabases = [
        "sjc_dev"
      ];

      enableTCPIP = true;

      identMap = ''
        # ArbitraryMapName systemUser DBUser
        superuser_map      root       postgres
        superuser_map      skarmux    postgres
        superuser_map      /^(.*)$    \1
      '';

      # database users can only access databases of the same name
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE DATABASE  USER      ADDRESS             METHOD  [OPTIONS]
        local  sameuser  all                           peer    map=superuser_map
        host   postgres  skarmux   192.168.178.152/32  scram-sha-256
        host   sjc_dev   skarmux   192.168.178.152/32  scram-sha-256
      '';
    };

    # TODO: Add later..
    # services.postgresqlBackup = {
    #   enable = false;
    # };
}