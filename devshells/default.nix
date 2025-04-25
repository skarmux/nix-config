{
  perSystem = { pkgs, ... }: {
    devShells = {
      default = pkgs.mkShell {
        packages = with pkgs;[
          nil # nix language server
          nixpkgs-fmt
          nh
          nixd
          nix-output-monitor # stylised wrapper around `nix`
          nvd # view packages diff between nix generations
              # ex: `nvd diff /nix/var/nix/profiles/system-{70,71}-link`
          deploy-rs
        ];
      };
      disko = import ./disko.nix { inherit pkgs; };
      sops = import ./sops.nix { inherit pkgs; };
    };
  };
}
