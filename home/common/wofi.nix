{ ... }:
{
  programs.wofi = {
    settings = {
      insensitive = true;
      # matching = "fuzzy";
      # show = "drun";
      allow_images = true;
      image_size = 48;
      # hide_search = true;
      prompt = "";
      no_actions = true;
      single_click = true;
      columns = 1;
      hide_scroll = true;
      # cache_file = "/dev/null";
      # normal_window = true;
    };
    style = /* css */ ''
      #img {
         padding: 1em;
      }
    '';
  };
}
