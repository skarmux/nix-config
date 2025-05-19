  { inputs, pkgs, ... }:
  {
    imports = [ ./skarmux.nix ];
    
    home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.bash;
    };
  }
