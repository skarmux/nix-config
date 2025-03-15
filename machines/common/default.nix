{ inputs, outputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./nix.nix
    ./openssh.nix
    ./persistence.nix
    ./sops.nix
    ./locale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment.systemPackages = with pkgs; [
    uutils-coreutils # https://uutils.github.io/coreutils/docs/index.html
    git
    home-manager
    du-dust # disk usage analyzer
    ripgrep # full-text search
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "backup"; # TODO A script to view and clean up all `backup` files
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  users.mutableUsers = false;

  system.stateVersion = "24.05";
}
