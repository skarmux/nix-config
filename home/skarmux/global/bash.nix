{ config, lib, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = config.programs.fish.shellAliases // config.programs.fish.shellAbbrs // {
      cd = lib.mkIf config.programs.zoxide.enable "z";
    };
    initExtra = "";
    # profileExtra = "${pkgs.nushell}/bin/nu";
  };

  # Override previous .bashrc without asking
  home.file.".bashrc".force = true;
}
