{
  imports = [
    # Shells
    ./bash.nix
    ./fish.nix
    ./nushell.nix

    # Multiplexer
    ./tmux.nix
    ./zellij
    #./mprocs
    
    ./yazi.nix
    ./zoxide.nix
    ./direnv.nix
    ./eza.nix
    ./starship.nix
  ];
}
