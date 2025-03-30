{ self, inputs, ... }:
{
  flake.nixosConfigurations = {

      ignika = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [ ./ignika ];
      };

  };
}
