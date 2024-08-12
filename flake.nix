{
  description = "Skarmux's nix-config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    nixgl = {
      url = "github:/nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hardware.url = "github:nixos/nixos-hardware";
    catppuccin.url = "github:catppuccin/nix";
    devshell.url = "github:numtide/devshell/main";
    impermanence.url = "github:nix-community/impermanence";
    deploy-rs.url = "github:serokell/deploy-rs";

    # Personal
    feaston.url = "github:skarmux/feaston";
    homepage.url = "github:skarmux/skarmux";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      pkgsFor =
        lib.genAttrs systems (system: import nixpkgs {
          inherit system;
          overlays = [
            inputs.nixgl.overlay
            inputs.devshell.overlays.default
          ];
        });
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    in {
      inherit lib;

      nixosModules = import ./modules/nixos;

      homeManagerModules = import ./modules/home-manager;

      apps = forEachSystem (pkgs: import ./apps { inherit pkgs; });

      overlays = import ./overlays { inherit inputs outputs; };

      devShell = forEachSystem (pkgs: import ./devshell.nix { inherit pkgs; });

      nixosConfigurations = {

        "ignika" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/ignika/configuration.nix ];
        };
        
        "teridax" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/teridax/configuration.nix ];
        };
        
        "pewku" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/pewku/configuration.nix ];
        };

      };

      homeConfigurations = {

        "steamdeck" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/steamdeck.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        
        "skarmux" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/default.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

      };

      deploy.nodes.pewku = {
        hostname = "${outputs.nixosConfigurations."pewku".config.networking.hostName}";
        fastConnection = true;
        interactiveSudo = false;
        confirmTimeout = 60;
        remoteBuild = false;

        profiles.system = {
          sshUser = "skarmux";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."pewku";
          user = "root";
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
