{ self, inputs, ... }:
{
  flake = {
    
    nixosModules = import ./modules;
    
    nixosConfigurations = {

      ignika = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [
          ./ignika
          {
            imports = builtins.attrValues self.nixosModules;
            networking.hostName = "ignika";
            system.stateVersion = "24.11";
          }
        ];
      };

    };
  };
}
