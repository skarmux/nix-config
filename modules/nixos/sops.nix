{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # NOTE: If you are using Impermanence, the key used for
  # secret decryption (sops.age.keyFile, or the host SSH keys)
  # must be in a persisted directory, loaded early enough 
  # during boot. For example:
  #
  # sops.age.keyFile = "/nix/persist/var/lib/sops-nix/key.txt";

  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
