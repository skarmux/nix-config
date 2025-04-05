{ self, inputs, ... }:
{
  flake.nixosConfigurations = {

      ignika = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [ ./ignika ];
      };

      # pewku = inputs.nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit self inputs; };
      #   modules = [ ./pewku ];
      # };

      # deploy.nodes.pewku = {
      #   hostname = "pewku";
      #   profiles.system = {
      #     user = "root";
      #     path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.pewku
      #   };
      # };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

  };
}
