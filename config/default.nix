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
          ./optional/hyprland.nix
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
          ./optional/hyprland.nix
          ./hardware/voyager.nix
          ./hardware/yubikey
          ./hardware/logitech_laser_mouse.nix
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
              (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
              inputs.home-manager.nixosModules.home-manager # needed by yubikey module
              inputs.sops-nix.nixosModules.sops
              ./global
            ];

            boot.kernelPackages = pkgs.linuxPackages_zen;

            # Template:
            # https://github.com/NixOS/nixpkgs/blob/be57485ffffe9398e2e58ae3f4d7608f55a8796d/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix

            isoImage.edition = "plasma6";
           
            services = {
              desktopManager.plasma6.enable = true;

              displayManager = {
                sddm.enable = true;
                autoLogin = {
                  enable = true;
                  user = "nixos";
                };
              };

              # Allow use of yubikeys
              yubikey-agent.enable = true; # SSH Agent
              pcscd.enable = true; # Smartcard functionality
              udev = {
                packages = with pkgs; [
                  yubikey-personalization
                ];
              };
            };

            environment.systemPackages = with pkgs; [
              maliit-framework
              maliit-keyboard
              yubikey-manager
              disko
              sops
              helix
              age
            ];

            environment.plasma6.excludePackages = with pkgs.kdePackages; [
              # Optional wallpapers that add 126 MiB to the graphical installer
              # closure. They will still need to be downloaded when installing a
              # Plasma system, though.
              plasma-workspace-wallpapers
            ];

            # Avoid bundling an entire MariaDB installation on the ISO.
            programs.kde-pim.enable = false;

            system.activationScripts.installerDesktop =
              let

                # Comes from documentation.nix when xserver and nixos.enable are true.
                manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

                homeDir = "/home/nixos/";
                desktopDir = homeDir + "Desktop/";

              in
              ''
                mkdir -p ${desktopDir}
                chown nixos ${homeDir} ${desktopDir}

                ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
                ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
                ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${
                  desktopDir + "io.calamares.calamares.desktop"
                }
              '';
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
