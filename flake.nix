{
  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./devshells
        ./home
        ./modules
        ./nixos
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
  
  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    deploy-rs.url = "github:serokell/deploy-rs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/v1.11.0";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.url = "github:danth/stylix";
    # Personal
    feaston.inputs.nixpkgs.follows = "nixpkgs";
    feaston.url = "git+ssh://git@github.com/skarmux/feaston.git";
    homepage.inputs.nixpkgs.follows = "nixpkgs";
    homepage.url = "git+ssh://git@github.com/skarmux/skarmux.git";
  };
}
