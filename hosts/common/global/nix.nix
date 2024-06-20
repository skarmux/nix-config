{
  nix = {

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    settings = {
      allowed-users = [ "@wheel" ];
      trusted-users = [ "skarmux" ];

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
