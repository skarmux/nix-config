{ config, lib, self, ... }:
{
  imports = [
    ./common/git
    ./common/helix
    ./common/shell
  ]
  ++ builtins.attrValues self.homeModules;

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "24.11";
    # packages = with pkgs; [
    # xh # http requests (like httpie)
    # dust # disk usage statistics
    # dua # disk usage analyzer (interactive)
    # hyperfine # benchmarking tool
    # rusty-man # crate docs in terminal
    # tokei # count lines of code per language
    # mask # declare build steps in markdown format
    # wiki-tui
    # ];
  };

  programs = {
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = lib.mkIf config.programs.tmux.enable "tmux";
    };
  };

  systemd.user.startServices = "sd-switch";
}
