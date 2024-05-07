{ pkgs, ... }:
{
  imports = [
    ./zellij
    ./direnv.nix
    ./ticker.nix
    ./bash.nix
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./starship.nix
    ./nextcloud.nix
  ];

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };

  home.packages = with pkgs; [
    vimv
    tree
    unzip
    cmatrix
    tty-clock
    fzf

    du-dust
    bat
    eza
    mprocs
    ripgrep
    speedtest-rs
    wiki-tui
    slides

    # Cross-platform Rust rewrite of the GNU coreutils
    uutils-coreutils

    # Could become an additional attack vector
    # calcurse
    # mutt
  ];
}
