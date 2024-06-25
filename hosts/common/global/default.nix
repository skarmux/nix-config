{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    ./nix.nix
    ./nix-ssh-serve.nix
    ./fish.nix
    ./protonvpn.nix
    ./openssh.nix
    ./persistence.nix
    ./sops.nix
    ./locale.nix
    ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment.systemPackages = with pkgs; [
    vim 
    git
    home-manager
  ];

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  users.mutableUsers = false;

  system.stateVersion = "24.05";
}
