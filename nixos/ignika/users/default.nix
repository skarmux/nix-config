  { pkgs, ... }:
  {
    imports = [ ./skarmux.nix ];
    
    home-manager.backupFileExtension = "backup";

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.bash;
    };
  }
