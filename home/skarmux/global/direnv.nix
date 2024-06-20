{
  programs.direnv = {
    enable = true;

    # Prevent project dependencies from being
    # garbage collected and speed up execution
    nix-direnv.enable = true;
  };

  programs.git.ignores = [ ".direnv/**" ];

  home.persistence."/nix/persist/home/skarmux" = {
    directories = [
      ".local/share/direnv/allow"
    ];
  };
}
