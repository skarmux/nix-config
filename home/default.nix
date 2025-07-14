{ self, inputs, ... }:
{
  flake.homeConfigurations = {

    skarmux = inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
      extraSpecialArgs = { inherit self inputs pkgs; };
      modules = [
        ./skarmux.nix
        {
          imports = [ inputs.sops-nix.homeManagerModules.sops ];
        }
      ];
    };

    deck = inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
      extraSpecialArgs = { inherit self inputs pkgs; };
      modules = [ ./deck.nix ];
    };

    # nix-on-droid = inputs.home-manager.lib.homeManagerConfiguration rec {
    #   pkgs = import inputs.nixpkgs {
    #     system = "aarch64-linux";
    #   };
    #   extraSpecialArgs = { inherit self inputs pkgs; };
    #   modules = [ ./nix-on-droid.nix ];
    # };

  };
}
