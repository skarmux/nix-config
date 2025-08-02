{
  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./config
        ./modules
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          shellHook = ''
          cat <<EOF
          Building an ISO:
          $ nix build .#nixosConfigurations.iso.config.system.build.isoImage

          Retrieve SSH key handles from Yubikey (~/.ssh/<here>):
          $ ssh-keygen -K

          Update SOPS secrets keys:
          $ sops updatekeys <path>/secrets.yml
          EOF
          '';
          packages = with pkgs;[
            nil # nix language server
            nixpkgs-fmt
            nh
            nixd
            nix-output-monitor # stylised wrapper around `nix`
            nvd # view packages diff between nix generations
            # ex: `nvd diff /nix/var/nix/profiles/system-{70,71}-link`
            sops
            ssh-to-age
            deploy-rs
            # gnupg
            # pinentry-curses
            age
          ];
        };
      };
    };

  nixConfig = {
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    deploy-rs.url = "github:serokell/deploy-rs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/v1.11.0";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-25.05";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    feaston.inputs.nixpkgs.follows = "nixpkgs";
    feaston.url = "git+ssh://git@github.com/skarmux/feaston.git";
    homepage.inputs.nixpkgs.follows = "nixpkgs";
    homepage.url = "git+ssh://git@github.com/skarmux/skarmux.git";
  };
}
