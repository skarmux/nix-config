{ self, inputs, ... }:
{
  flake = {
    nixosConfigurations = {

      ignika = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [ ./ignika ];
      };

      # Raspberry Pi
      
      pewku = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        modules = [ ./pewku ];
      };

      iso = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ({ pkgs, modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
            environment.systemPackages = with pkgs; [
              disko
              git
              helix
              sops
              ssh-to-age
              gnupg
              pinentry-curses
              age
            ];
            networking = {
              networkmanager.enable = true;

              # Does not disable wireless but a tool called `wireless`
              wireless.enable = false;
            };

            services.openssh = {
              enable = true;
              settings = {
                PermitRootLogin = "yes";
                PasswordAuthentication = true;
              };
            };

            users.users =
            let
              keys = [
                "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOkPglvGlOsIUrTMQdL7DLPMXmDRzYF3wJzH/Ee2VU/dAAAABHNzaDo= skarmux@ignika"
                "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBZmLgjKCWzv8nWieD5rQKpOBJnRXGZxqtXk9o5peHpZAAAABHNzaDo= skarmux@ignika"
              ];
            in
            {
              root.openssh.authorizedKeys = {
                inherit keys;
              };
              nixos.openssh.authorizedKeys = {
                inherit keys;
              };
            };
          })
        ];
      };

    };

    deploy.nodes.pewku = {
      hostname = "pewku";
      profiles.system = {
        sshUser = "skarmux";
        user = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.pewku;
      };
    };

    checks = builtins.mapAttrs (system: deployLib:
      deployLib.deployChecks self.deploy
    ) inputs.deploy-rs.lib;
  };
}
