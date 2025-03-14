{
  nix = {

    # Serve the nix store binaries to other network clients
    sshServe = {
      enable = true;
      keys = [
        # TODO Is that the yubikey public?
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOHnEYhX+q+xTVjoIIAjT+tn1NVAtqLjkE8J88YS14w skarmux"
      ];
      protocol = "ssh";
      # Whether to enable writing to the Nix store as a remote store via SSH. 
      # Note: the sshServe user is named nix-ssh and is not a trusted-user. 
      # nix-ssh should be added to the nix.settings.trusted-users option in 
      # most use cases, such as allowing remote building of derivations.
      write = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    settings = {
      allowed-users = [ "@wheel" ];
      trusted-users = [
        "nix-ssh" # allow writing to nix store via remote ssh
      ];

      experimental-features = "nix-command flakes";
      
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.skarmux.tech"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.skarmux.tech:IkJHXpLsX5SxtSiBjkQ+MZzjR5ZImNV/wiItHTYSjV0="
      ];

    };
  };
}
