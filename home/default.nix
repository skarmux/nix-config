{ self, inputs, ... }:
{
  flake = {
  
    homeModules = import ./modules;
  
    homeConfigurations = {

      skarmux = inputs.home-manager.lib.homeManagerConfiguration rec {
        extraSpecialArgs = { inherit self inputs pkgs; };
        modules = [ ./skarmux/home.nix ];
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
        };
      };

    };
  };
}
