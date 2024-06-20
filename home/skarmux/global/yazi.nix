{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 8;
      };
      preview = {
        image_filter = "nearest";
        image_quality = 50; # 50-90
      };
      opener = {
        edit = [
          { run = ''nvim "$0"''; block = true;}
        ];
        play = [
          { run = ''celluloid "$0"''; orphan = true; }
        ];
        open = [
          { run = ''zathura "$0"''; orphan = true; }
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
  };
}
