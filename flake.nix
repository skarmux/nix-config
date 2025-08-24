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
          Deploy to pewku using dedicated ssh key:
          $ deploy .#pewku --ssh-opts "-i ~/.ssh/pewku-deployment/id_ed25519"
          
          Building an ISO:
          $ nix build .#nixosConfigurations.iso.config.system.build.isoImage

          Retrieve SSH key handles from Yubikey (~/.ssh/<here>):
          $ ssh-keygen -K

          Update SOPS secrets keys:
          $ sops updatekeys <path>/secrets.yml

          Installation:
          $ disko --mode disko --flake .#<sys>
          $ mkdir -p /mnt/persist/etc/ssh
          $ ssh-keygen -A -f /mnt/persist
          $ mkdir -p ~/.config/sops/age
          $ cp <keys.txt> ~/.config/sops/age/keys.txt
          $ ssh-to-age < /mnt/persist/etc/ssh/ssh_host_ed25519.pub
          > age$...
          $ hx .sops.yaml
          $ sops updatekeys config/nixos/<sys>/secrets.yaml
          $ sops updatekeys config/hardware/yubikey/secrets.yaml
          $ sudo nixos-install --flake .#<sys> --no-root-password
          EOF

          rbtohex() {
              ( od -An -vtx1 | tr -d ' \n' )
          }

          hextorb() {
              ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
          }          
          '';
          packages = with pkgs;[
            nil # nix language server
            nixpkgs-fmt # formatter
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
            # Yubikey FDE
            yubikey-personalization
            openssl
            gcc
          ];
        };
      };
    };

  nixConfig = {
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    feaston = {
      url = "git+ssh://git@github.com/skarmux/feaston.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homepage = {
      url = "git+ssh://git@github.com/skarmux/skarmux.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
