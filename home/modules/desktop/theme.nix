{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  catppuccin = {
    enable = true; # global
    flavor = "mocha";
    accent = "mauve";
  };

  catppuccin.tmux.extraConfig = /* sh */ ''
    # set -g @catppuccin_status_modules_left "session"
    # set -g @catppuccin_window_number_position "left"
    # set -g @catppuccin_window_default_fill "number"
    # set -g @catppuccin_window_default_text "#W"
    # set -g @catppuccin_window_current_fill "number"
    # set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
    set -g @catppuccin_window_status_style "rounded"

    # Make the status line pretty and add some modules
    set -g status-right-length 100
    set -g status-left-length 100
    set -g status-left ""
    set -g status-right "#{E:@catppuccin_status_application}"
    set -agF status-right "#{E:@catppuccin_status_cpu}"
    set -ag status-right "#{E:@catppuccin_status_session}"
    set -ag status-right "#{E:@catppuccin_status_uptime}"
    set -agF status-right "#{E:@catppuccin_status_battery}"

    # set -g @catppuccin_status_modules_right "cpu date_time host"
    # set -g @catppuccin_status_connect_separator "no"
    # set -g @catppuccin_status_background "default"
    # set -g @catppuccin_status_fill "icon"

    set -g @catppuccin_directory_text "#{b:pane_current_path}"
    # set -g @catppuccin_date_time_text "%H:%M"

    # set -g @catppuccin_status_left_separator " █"
    # set -g @catppuccin_status_right_separator "█"
    # set -g @catppuccin_window_left_separator " █"
    # set -g @catppuccin_window_right_separator "█"
    # set -g @catppuccin_window_middle_separator "█ "
  '';
}
