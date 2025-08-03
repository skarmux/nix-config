{ inputs, self, ... }:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs self; };
    backupFileExtension = "backup";
    useUserPackages = true;
    useGlobalPkgs = false;
    # Use additional userspace sops secrets
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
