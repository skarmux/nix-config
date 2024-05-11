{ pkgs }:
pkgs.mkShell {

  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

  shellHook = /* bash */ ''
    export GPG_TTY=$(tty)
    chsh -s /usr/bin/fish
  '';

  nativeBuildInputs = with pkgs; [
    home-manager
    git

    openssh
    sops
    ssh-to-age
      # gnupg
      # age
  ];
}
