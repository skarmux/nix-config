{ ... }:
{
  services.dunst = {
    enable = true;
    # iconTheme = {};
    settings = {
      global = {
        # icon_path = "";
        monitor = 0;
        follow = "none";

        ### Geometry
        width = "(100,600)";
        height = "(0,300)";
        origin = "top-center";
        offset = "(0,10)";
        scale = 4;
        notification_limit = 3;

        ### Progress bar
        progress_bar = true;
        progress_bar_height = 14;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 100;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 50;
        progress_bar_corners = "bottom-left, top-right";
        icon_corner_radius = 0;
        icon_corners = "all";
        indicate_hidden = "yes";
        # transparency = 0;
        separator_height = 6;
        padding = 10;
        horizontal_padding = 8;
        text_icon_padding = 12;
        frame_width = 2;
        # frame_color = "#a0a0a0";
        gap_size = 10;
        # separator_color = "frame";
        sort = "yes";

        ### Text
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "center";
        vertical_alignment = "center";
        show_age_threshold = -1;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";

        ### Icons
        enable_recursive_icon_lookup = true;
        # icon_theme = "Adwaita, Papirus, Papirus-Dark";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        # icon_path = ./;

        ### History
        sticky_history = "yes";
        history_length = 30;

        ### Misc/Advanced
        # dmenu = /usr/bin/dmenu -l 10 -p dunst:
        # browser = /usr/bin/xdg-open;
        always_run_script = true;
        corner_radius = 10;
        corners = "all";
        ignore_dbusclose = false;

        ### Wayland
        force_xwayland = false;

        ### Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      # urgency_low = { };
      # urgency_normal = { };
      # urgency_critical = { };
    };
    # configFile = ;
  };
}
