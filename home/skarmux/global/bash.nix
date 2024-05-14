{ config, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = config.programs.fish.shellAliases;
    initExtra = "";
    profileExtra = "";
  };

  home.file.".bashrc".force = true;
}
