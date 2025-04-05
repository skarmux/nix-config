{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # NOTE: If you are using Impermanence, the key used for
  # secret decryption (sops.age.keyFile, or the host SSH keys)
  # must be in a persisted directory, loaded early enough 
  # during boot. For example:
  #
  # sops.age.keyFile = "/nix/persist/var/lib/sops-nix/key.txt";

  # Required for password to be set via sops during system activation!
  users.mutableUsers = false;

  sops = {
    validateSopsFiles = false;
    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      # these will use an age key that is expected to already be in the filesystem
      # keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      # generateKey = true;
    };
  };
  
  # Sops needs access to persisted private keys to
  # generate /run/secrets before booting is completed
  fileSystems."/persist".neededForBoot = true;

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
