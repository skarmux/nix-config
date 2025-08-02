{
    nix.sshServe = {
      enable = true;
      keys = [
        # Public keys allowed to access the binary cache of this host
        (builtins.readFile ../../teridax/ssh_host_ed25519_key.pub)
        (builtins.readFile ../../pewku/ssh_host_ed25519_key.pub)
      ];
      protocol = "ssh";
      # Whether to enable writing to the Nix store as a remote store via SSH. 
      # Note: the sshServe user is named nix-ssh and is not a trusted-user. 
      # nix-ssh should be added to the nix.settings.trusted-users option in 
      # most use cases, such as allowing remote building of derivations.
      write = true;
    };

    nix.settings = {
      trusted-users = [ "nix-ssh" ];
    };
}