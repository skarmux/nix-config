{
    # services.postgresql = {
    #   enable = true;
    #   ensureDatabases = [ "sjc" ];
    #   enableTCPIP = true;
    #   # port = 5432;
    #   # database users can only access databases of the same name
    #   authentication = pkgs.lib.mkOverride 10 ''
    #     #type database  DBuser  auth-method   optional_ident_map
    #     local sameuser  all     peer          map=superuser_map
    #     # ipv4
    #     host  all       all     127.0.0.1/32  trust
    #     # ipv6
    #     host  all       all     ::1/128       trust
    #   '';
    #   identMap = ''
    #     # ArbitraryMapName systemUser DBUser
    #     superuser_map      root      postgres
    #     superuser_map      skarmux   postgres
    #     # Let other names login as themselves
    #     superuser_map      /^(.*)$   \1
    #   '';
    #   initialScript = pkgs.writeText "backend-initScript" ''
    #     CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
    #     CREATE DATABASE nixcloud;
    #     GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    #   '';
    # };
    # /postgres
}