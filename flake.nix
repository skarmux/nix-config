{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # Home-Manager module
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    feaston.url = "github:skarmux/feaston";

    nixgl.url = "github:/nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
            # inputs.deploy-rs.overlays.default
            # (self: super: { 
            #   deploy-rs = { 
            #     inherit (super) deploy-rs; 
            #     lib = super.deploy-rs.lib; 
            #   }; 
            # })
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
      # formatter = forEachSystem (pkgs: pkgs.nixfmt-classic);

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
          modules = [
            ./hosts/pewku/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "skarmux@ignika" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/ignika.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "deck@steamdeck" = lib.homeManagerConfiguration {
          modules = [ ./home/deck/steamdeck.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "skarmux@teridax" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/teridax.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "skarmux@wsl" = lib.homeManagerConfiguration {
          modules = [ ./home/skarmux/default.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      deploy.nodes.pewku = {
        hostname = "192.168.178.99";
        fastConnection = true;
        interactiveSudo = true;
        confirmTimeout = 60;
        remoteBuild = false;

        profiles.system = {
          sshUser = "skarmux";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."pewku";
          user = "root";
        };

        # profiles.feaston = {
        #   sshUser = "feaston";
        #   path = inputs.deploy-rs.lib.aarch64-linux.activate.custom
        #     self.defaultPackage.aarch64-linux "./bin/activate";
        #   user = "feaston";
        # };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
