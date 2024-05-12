{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell/main";
    impermanence.url = "github:nix-community/impermanence";

    # Manage disk format and partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Simplify hardware configuration
    hardware.url = "github:nixos/nixos-hardware";

    # Global theming 
    catppuccin.url = "github:catppuccin/nix";

    # Secrets management
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Home-Manager module
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprlock.url = "github:hyprwm/Hyprlock";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";

    nixgl.url = "github:/nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # My own self hosted projects
    feaston.url = "github:skarmux/feaston";
    feaston.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor =
        lib.genAttrs systems (system: import nixpkgs {
          inherit system;
          overlays = [
            inputs.nixgl.overlay
            inputs.devshell.overlays.default
          ];
        });
    in {
      inherit lib;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      apps = forEachSystem (pkgs: import ./apps { inherit pkgs; });

      overlays = import ./overlays { inherit inputs outputs; };

      devShell = forEachSystem (pkgs: import ./devshell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixfmt-classic);

      nixosConfigurations = {
        "ignika" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/ignika ];
        };
        "teridax" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/teridax ];
        };
        "pewku" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/pewku ];
        };
      };

      homeConfigurations = {
        "skarmux@ignika" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/ignika.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "skarmux@steamdeck" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/steamdeck.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "skarmux@teridax" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/teridax.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "skarmux@pewku" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/pewku.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      deploy.nodes."pewku" = {
        hostname = "pewku";
        fastConnection = true;
        interactiveSudo = true;
        confirmTimeout = 60;
        remoteBuild = false;

        profiles.system = {
          user = "root";
          sshUser = "skarmux";
          path = deploy-rs.lib.aarch64-linux.activate.nixos
            self.nixosConfigurations."pewku";
        };

        profiles.feaston = {
          user = "feaston";
          sshUser = "skarmux";
          path = deploy-rs.lib.aarch64-linux.activate.custom
            inputs.feaston.packages.aarch64-linux.default "./bin/activate";
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
