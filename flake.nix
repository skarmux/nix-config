{
  description = "Skarmux's nix-config";

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./home
        ./nixos
        ./devshells
      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
  
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.home-manager.follows = "home-manager";
    };
    hardware.url = "github:nixos/nixos-hardware";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    catppuccin.url = "github:catppuccin/nix";
    impermanence.url = "github:nix-community/impermanence";
    deploy-rs.url = "github:serokell/deploy-rs";
    feaston.url = "github:skarmux/feaston";
    homepage.url = "github:skarmux/skarmux";
  };
}
