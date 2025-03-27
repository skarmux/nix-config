{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    # Number row on keyboard starts at 1
    baseIndex = 1;
    mouse = true;
    disableConfirmationPrompt = true;
    clock24 = false;
    historyLimit = 10000;

    plugins = with pkgs; [
      tmuxPlugins.sensible 
      tmuxPlugins.yank
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
      set -g status off # disable the status bar
      set -g default-terminal "tmux-256color"
      # set -g renumber-windows on # prevent numbering gaps
      set -g status-position top # opposite of vim statusline
      set -g set-clipboard on    # use system clipboard

      # reload tmux conf
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };
}
