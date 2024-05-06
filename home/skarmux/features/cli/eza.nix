{
  programs.eza = {
    enable = true;

    # enableFishIntegration = true;
    # enableBashIntegration = true;
    # Whether to enable recommended eza aliases
    # ls, ll, la, lt & lla
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    # List each file’s Git status if tracked or ignored
    git = true;

    # Display icons next to filenames
    icons = true;

    extraOptions = [ "--time-style=iso" "--group-directories-first" ];
  };
}
