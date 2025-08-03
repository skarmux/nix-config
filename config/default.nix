{ self, inputs, ... }:
# Here I'm setting up all home-/nixosConfigurations and assign modules from
# the flake inputs to each. I don't want to pass `inputs` further down beyond
# this point to keep things organized. (Unless it's for accessing files from
# a non-flake source.)
{
  flake = {

    homeConfigurations = {

      ##############
      # WORK / WSL #
      ##############

      skarmux = inputs.home-manager.lib.homeManagerConfiguration rec {
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
        };
        extraSpecialArgs = { inherit self inputs pkgs; };
        modules = builtins.attrValues self.homeModules ++ [
          inputs.stylix.homeModules.stylix
          ./home/base.nix
          ./home/hackthebox.nix
        ];
      };

      ##############
      # STEAM DECK #
      ##############

      deck = inputs.home-manager.lib.homeManagerConfiguration rec {
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
        };
        extraSpecialArgs = { inherit self inputs pkgs; };
        modules = builtins.attrValues self.homeModules ++ [
          inputs.stylix.homeModules.stylix
          ./home/base.nix
          {
            home.username = "deck";
          }
        ];
      };

    };

    nixosConfigurations = {

      ###########
      # DESKTOP #
      ###########

      ignika = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "x86_64-linux";
        modules = (builtins.attrValues self.nixosModules) ++ [
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./global
          ./hardware/voyager.nix
          ./hardware/benq_rd280ua.nix
          ./hardware/lg_tv_sscr2
          ./hardware/sony_wh-xm4-1000.nix
          ./hardware/yubikey
          ./hardware/logitech_g502.nix
          ./hardware/sony_dualsense.nix
          ./nixos/ignika
          {
            home-manager.users.skarmux = {
              imports = builtins.attrValues self.homeModules ++ [
                inputs.stylix.homeModules.stylix
                ./home/base.nix
                ./home/desktop.nix
                ./home/games.nix
                ./home/hackthebox.nix
              ];
            };
          }
        ];
      };

      ##########
      # LAPTOP #
      ##########

      teridax = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "x86_64-linux";
        modules = builtins.attrValues self.nixosModules ++ [
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./global
          ./hardware/voyager.nix
          ./hardware/yubikey
          ./nixos/teridax
          {
            home-manager.users.skarmux = {
              imports = builtins.attrValues self.homeModules ++ [
                inputs.stylix.homeModules.stylix
                ./home/base.nix
                ./home/desktop.nix
                ./home/hackthebox.nix
              ];
            };
          }
        ];
      };

      ##################
      # HOMELAB SERVER #
      ##################

      pewku = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "aarch64-linux";
        modules = builtins.attrValues self.nixosModules ++ [
          inputs.feaston.nixosModules.default
          inputs.homepage.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
          inputs.hardware.nixosModules.raspberry-pi-4  
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./global
          ./hardware/yubikey
          ./nixos/pewku
          {
            home-manager.users.skarmux = {
              imports = builtins.attrValues self.homeModules ++ [
                ./home/base.nix
              ];
            };
          }
        ];
      };

      ###############
      # INSTALL ISO #
      ###############

      # Keep it minimal, as everything has to live within ram!

      iso = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "x86_64-linux";
        modules = builtins.attrValues self.nixosModules ++ [
          ({ pkgs, modulesPath, ... }: {
            imports = [
              (modulesPath + "/installer/cd-dvd/installation-cd-graphical-plasma5.nix")
              inputs.home-manager.nixosModules.home-manager
              # inputs.sops-nix.nixosModules.sops
              # ./global
            ];
            yubico.enable = true; # requires home-manager
            environment.systemPackages = with pkgs; [
              disko
              sops
              helix
              age
            ];
          })
        ];
      };

    };

    #####################
    # REMOTE DEPLOYMENT #
    #####################

    deploy.nodes.pewku = {
      hostname = "pewku";
      profiles.system = {
        sshUser = "skarmux";
        user = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.pewku;
      };
    };

    checks = builtins.mapAttrs
      (system: deployLib:
        deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
  };
}
