{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Required for password to be set via sops during system activation!
  users.mutableUsers = false;

  sops = {
    validateSopsFiles = false;
    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
  
  # Sops needs access to persisted private keys to
  # generate /run/secrets before booting is completed
  fileSystems."/persist".neededForBoot = true;

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
