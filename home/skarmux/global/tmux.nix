{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    catppuccin = {
      extraConfig = ''
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"

      set -g @catppuccin_status_modules_right "directory meetings date_time"
      set -g @catppuccin_status_modules_left "session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_status_background "default"

      set -g @catppuccin_directory_text "#{b:pane_current_path}"
      #set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
      set -g @catppuccin_date_time_text "%H:%M"
      '';
    };

    # Number row on keyboard starts at 1
    baseIndex = 1;

    # shortcut = "b";
    disableConfirmationPrompt = true;
    clock24 = true;

    /*
    set -g @plugin 'fcsonline/tmux-thumbs'
    set -g @plugin 'sainnhe/tmux-fzf'
    set -g @plugin 'wfxr/tmux-fzf-url'
    */
    plugins = with pkgs; [
      tmuxPlugins.sensible 
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
        set -g @resurrect-strategy-nvim "session"
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
        set -g @continuum-restore "on"
        '';
      }
    ];
    
    extraConfig = ''
    set -g renumber-windows on
    set -g status-position top # opposite of vim statusline
    set -g set-clipboard on    # use system clipboard
    '';
  };
}
