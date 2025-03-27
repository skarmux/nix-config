{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.gnupg.home = "${config.programs.gpg.homedir}";
}
