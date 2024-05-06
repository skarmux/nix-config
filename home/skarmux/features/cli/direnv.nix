{
  programs.direnv = {
    enable = true;

    # Prevent project dependencies from being
    # garbage collected and faster execution
    nix-direnv.enable = true;
  };
}
