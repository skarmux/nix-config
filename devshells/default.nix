{
  perSystem = { pkgs, ... }: {
    devShells = {
      default = pkgs.mkShell {
        packages = with pkgs;[
          nil
          nixpkgs-fmt
          nh
        ];
      };
      disko = import ./disko.nix { inherit pkgs; };
      sops = import ./sops.nix { inherit pkgs; };
    };
  };
}
