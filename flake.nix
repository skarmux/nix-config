{
  description = "Skarmux's nix-config";

  outputs = inputs @ { flake-parts, deploy-rs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./devshells
        ./overlays
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
    home-manager.url = "github:nix-community/home-manager";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.url = "github:danth/stylix";
    # Personal
    feaston.url = "git+ssh://git@github.com/skarmux/feaston.git?ref=main&shallow=1";
    homepage.url = "git+ssh://git@github.com/skarmux/skarmux.git?ref=main&shallow=1";
  };
}
