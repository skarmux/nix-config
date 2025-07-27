{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { inherit inputs self; };
    backupFileExtension = "backup";
    useGlobalPkgs = false;
    useUserPackages = true;
  };
}
