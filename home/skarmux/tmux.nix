{ pkgs, ... }:
{
  programs.tmux = {
    baseIndex = 1;
    mouse = true;
    disableConfirmationPrompt = true;
    clock24 = false;
    plugins = with pkgs; [
      # Sensible default settings for tmux
      tmuxPlugins.sensible
      # Copy to system clipboard
      {
        plugin = tmuxPlugins.yank;
        extraConfig = /* sh */ ''
          set -g set-clipboard on
        '';
      }
      {
        # Automatically save and restore tmux environment
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
      set -g default-terminal "tmux-256color"
      set -g renumber-windows on # prevent numbering gaps
      set -g status-position top # opposite of vim statusline

      # reload tmux conf
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };

  catppuccin.tmux.extraConfig = /* sh */ ''
    # Make the status line background transparent
    # default | none | #{@thm_<color>}
    set -g @catppuccin_status_background "#{@thm_bg}"

    # Change the style of status line elements
    set -g @catppuccin_window_status_style "rounded"
    
    # Make the status line more pleasant by hiding the
    # session id `[n] `
    set -g status-left ""
    # set -g status-left "#{E:@catppuccin_status_session}"

    # Ensure that everything on the right side of the status line
    # is included.
    set -g status-right-length 100

    # Make background the same as the status line background
    set -g @catppuccin_status_module_crust_color "#{@thm_bg}"

    # Place status elements
    set -g status-right "#{E:@catppuccin_status_session}"
    # -a: append
    set -ag status-right "#{E:@catppuccin_status_date_time}"

    # set -g @catppuccin_date_time_text "%H:%M"
    # set -g @catppuccin_status_connect_separator "no"
    # set -g @catppuccin_status_fill "icon"
    # set -g @catppuccin_status_right_separator_inverse "no"
    # set -g @catppuccin_window_current_fill "number"
    # set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
    # set -g @catppuccin_window_default_fill "number"
    # set -g @catppuccin_window_default_text "#W"
    # set -g @catppuccin_window_number_position "right"
  '';
}
