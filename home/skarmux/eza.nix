{ config, ... }:
{
  programs.eza = {
    # Whether to enable recommended eza aliases
    # ls, ll, la, lt & lla
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    # List each file’s Git status if tracked or ignored
    git = config.programs.git.enable;

    # Display icons next to filenames
    # Gaps can be adjusted with an environment variable
    icons = "auto";

    extraOptions = [
      "--time-style=iso"
      "--group-directories-first"
    ];
  };
}
