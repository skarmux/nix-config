{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = config.programs.fish.shellAliases // config.programs.fish.shellAbbrs;
    initExtra = "";
    # profileExtra = "${pkgs.nushell}/bin/nu";
  };

  # Override previous .bashrc without asking
  home.file.".bashrc".force = true;
}
