  { pkgs, ... }:
  {
    imports = [ ./skarmux.nix ];
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.bash;
    };
  }
