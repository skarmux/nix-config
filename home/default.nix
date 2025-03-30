{ self, inputs, ... }:
{
  flake.homeConfigurations = {

    skarmux = inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
      extraSpecialArgs = { inherit self inputs pkgs; };
      modules = [ ./skarmux/home.nix ];
    };

  };
}
