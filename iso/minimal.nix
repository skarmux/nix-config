{ self, inputs, pkgs, hostPlatform, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    self.nixosModules.home-manager
    self.nixosModules.shell
  ];

  nix.settings.experimental-features = [ "nix-command" "flake" ];

  nixpkgs = { inherit hostPlatform; };

  environment.systemPackages = with pkgs; [
    git
    disko
    helix
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
}
