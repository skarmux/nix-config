{ config, ... }:
{
  programs.eza = {
    enable = true;

    # Whether to enable recommended eza aliases
    # ls, ll, la, lt & lla
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;

    # List each file’s Git status if tracked or ignored
    git = config.programs.git.enable;

    # Display icons next to filenames
    icons = "auto";

    extraOptions = [
      "--time-style=iso"
      "--group-directories-first"
    ];
  };
}
