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
        ratio = [ 1 2 3 ];
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
        image_quality = 70; # 50-90
      };
      opener = {
        play = [ ] ++ (lib.optionals (hasPackage "celluloid") [
          {
            run = ''${pkgs.celluloid}/bin/celluloid "$0"'';
            orphan = true;
          }
        ]);
        edit = [
          {
            run = ''$EDITOR "$0"'';
            block = false;
            orphan = true;
            desc = "Default editor";
          }
        ];
        open = [ ] ++ (lib.optionals (hasPackage "evince") [
          {
            run = ''${pkgs.evince}/bin/evince "$0"'';
            orphan = true;
          }
        ]);
      };
      open = {
        rules = [
          { mime = "text/*"; use = "edit"; }
          { mime = "video/*"; use = "play"; }
          
          # { mime = "application/json", use = "edit" }
          { name = "*.json"; use = "edit"; }

          # Multiple openers for a single file
          { name = "*.html"; use = [ "open" "edit" ]; }
        ];
      };
    };
  };
}
