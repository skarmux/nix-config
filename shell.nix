{ pkgs ? import <nixpkgs> {}, ... }:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    GPG_TTY = "$(tty)"; # Allow entering (yubikey) gpg passwords within tty
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      helix
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
