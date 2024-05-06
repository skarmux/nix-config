{ config, ... }: {
  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      global = {
        # %a appname
        # %s summary
        # %b body
        # %i iconname (including its path)
        # %I iconname (without its path)
        # %p progress value ([ 0%] to [100%])
        # %n progress value without any extra characters
        # %% Literal %
        format = ''
          <b>%s</b>
          %b'';
        vertical_alignment = "left";
        show_indicators = "no"; # actions (A) and urls (U)
        width = "(0,500)";
        height = "(0,300)";
        # offset = "10x10"; # horizontal x vertical
        origin = "top-right";
        layer = "overlay";
        font = "${config.fontProfiles.regular.family} 12";
        transparency = 0; # 0 is 100% opaque
        icon_theme = config.gtk.iconTheme.name;
        separator_height = 4;
        padding = 10;
        horizontal_padding = 10;
        frame_width = 2; # disabled
        corner_radius = 10;
      };
      urgency_normal = { timeout = 15; };
    };
  };
}
