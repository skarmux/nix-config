# https://yazi-rs.github.io/docs/configuration/yazi/
{ config, lib, pkgs, ... }:
let
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
in
{
  programs.yazi = {

    shellWrapperName = "y";

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        ratio = [ 1 3 1];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 8;
        title_format = "";
      };
      preview = {
        wrap = "no";
        tab_size = 2;
        image_filter = "nearest";
        image_quality = 50; # 50-90
      };
      opener = {
        play = [
          # {
          #   run = ''celluloid "$0"'';
          #   orphan = true;
          # }
        ];
        edit = [
          {
            run = ''$EDITOR "$0"'';
            block = false;
            orphan = true;
            desc = "Default editor";
          }
        ];
        open = [
          # {
          #   run = ''evince "$0"'';
          #   orphan = true;
          # }
        ];
        bulk-rename = [{
          run = ''$EDITOR "$@"'';
          block = true;
        }];
      };
      open = {
        prepend_rules = [
          { name = "bulk-rename.txt"; use = "bulk-rename"; }
        ];
        rules = [
          { mime = "text/*"; use = "edit"; }
          { mime = "video/*"; use = "play"; }
          
          # { mime = "application/json", use = "edit" }
          { name = "*.json"; use = "edit"; }
          { name = "*.typ"; use = "edit"; }

          # Multiple openers for a single file
          { name = "*.html"; use = [ "open" "edit" ]; }
        ];
      };
    };
  };
}
