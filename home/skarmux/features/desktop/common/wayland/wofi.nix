{
  programs.wofi = {
    enable = true;

    # manpage wofi(5)
    settings = {
      insensitive = true;
      matching = "fuzzy";
      show = "drun";
      allow_images = true;
      image_size = 48;
      prompt = "";
      no_actions = true;
      single_click = true;
      columns = 1;
      cache_file = "/dev/null";
      normal_window = true;
    };
  }; # programs.wofi
}
