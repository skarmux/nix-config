{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./nix.nix
    ./fish.nix
    ./protonvpn.nix
    ./gpg.nix
    ./openssh.nix
    ./optin-persistence.nix
    ./sops.nix
    ./locale.nix
    ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment.systemPackages = with pkgs; [ vim ];

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  users.mutableUsers = false;

  system.stateVersion = "24.05";
}
