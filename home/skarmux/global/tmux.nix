{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    catppuccin = {
      extraConfig = /* sh */ ''
      set -g @catppuccin_status_modules_left "session"
      
      set -g @catppuccin_window_number_position "left"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"

      set -g @catppuccin_status_modules_right "cpu date_time"
      
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_status_background "default"
      set -g @catppuccin_status_fill "icon"

      set -g @catppuccin_directory_text "#{b:pane_current_path}"
      set -g @catppuccin_date_time_text "%H:%M"

      set -g @catppuccin_status_left_separator " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_window_left_separator " "
      set -g @catppuccin_window_right_separator ""
      set -g @catppuccin_window_middle_separator "█ "
      '';
    };

    # Number row on keyboard starts at 1
    baseIndex = 1;
    mouse = true;
    disableConfirmationPrompt = true;
    clock24 = true;
    historyLimit = 10000;

    /*
    set -g @plugin 'fcsonline/tmux-thumbs'
    set -g @plugin 'sainnhe/tmux-fzf'
    set -g @plugin 'wfxr/tmux-fzf-url'
    */
    plugins = with pkgs; [
      tmuxPlugins.sensible 
      tmuxPlugins.yank
      tmuxPlugins.cpu
      tmuxPlugins.net-speed
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = /* sh */ ''
        set -g @resurrect-strategy-nvim "session"
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = /* sh */ ''
        set -g @continuum-restore "on"
        '';
      }
    ];
    
    extraConfig = /* sh */ ''
    set -g renumber-windows on # prevent numbering gaps
    set -g status-position top # opposite of vim statusline
    set -g set-clipboard on    # use system clipboard
    '';
  };
}
