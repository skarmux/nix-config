  { pkgs, ... }:
  {
    imports = [ ./skarmux.nix ];
    users.defaultUserShell = pkgs.bash;
  }
