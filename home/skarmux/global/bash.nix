{ config, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = config.programs.fish.shellAliases // config.programs.fish.shellAbbrs;
    initExtra = "";
    profileExtra = "";
  };

  home.file.".bashrc".force = true;
}
