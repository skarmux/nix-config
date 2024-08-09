{ config, ... }:
{
  programs.nixvim.plugins = {
    obsidian = {
      enable = true;
      settings = {
        workspaces = [{
          name = "personal";
          path = "${config.xdg.userDirs.documents}/obsidian";
        }];
      };
    };
  };
}
