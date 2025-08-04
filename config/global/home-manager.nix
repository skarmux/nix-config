{ inputs, self, ... }:
{
  home-manager = {
    # TODO: I kept on getting error messages, that unfree package xy wasn't
    #       allowed, although I've added it to `allowUnfreePredicate`.
    #       Started having issues with this after disabling the soon to be
    #       deprecated `useGlobalPkgs`. The `allowUnfreePredicate` needs to
    #       be within home-manager's scope, so I opted for adding `pkgs` to
    #       `extraSpecialArgs` to make it work after I found this might
    #       be the solution to fix that. And it worked. Can't explain how...
    extraSpecialArgs = { inherit inputs self; };
    backupFileExtension = "backup";

    # Something with `users.users.<username>.packages`
    useUserPackages = false;

    # Use nixpkgs configuration from nixos in home-manager as well.
    # (Makes standalone home-manager diverge)
    useGlobalPkgs = false;

    # Use additional userspace sops secrets
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };

}
