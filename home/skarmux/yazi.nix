{
  programs.yazi = {
    enableNushellIntegration = true;
    settings = {
      # https://yazi-rs.github.io/docs/configuration/yazi/
      manager = {
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 8;
      };
      preview = {
        wrap = "yes";
        image_filter = "nearest";
        image_quality = 50; # 50-90
      };
      opener = {
        edit = [
          { run = ''hx "$0"''; block = true;}
        ];
        play = [
          { run = ''celluloid "$0"''; orphan = true; }
        ];
        open = [
          { run = ''evince "$0"''; orphan = true; }
        ];
      };
      open = {
        rules = [
          { mime = "text/*"; use = "edit"; }
          { mime = "video/*"; use = "play"; }
          { name = "*.json"; use = "edit"; }
          { name = "*.html"; use = [ "open" "edit" ]; }
        ];
      };
    };
    shellWrapperName = "y";
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
