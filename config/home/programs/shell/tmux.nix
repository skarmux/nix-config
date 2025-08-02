{ pkgs, ... }:
{
  programs.tmux = {
    baseIndex = 0;
    mouse = true;
    disableConfirmationPrompt = true;
    clock24 = false;
    plugins = [
      # Sensible default settings for tmux
      pkgs.tmuxPlugins.sensible
      {
        # Copy to system clipboard
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = ''
          set -g set-clipboard on
        '';
      }
    ];

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -g renumber-windows on # prevent numbering gaps
      set -g status-position top # opposite of vim statusline
      set -g status off
    '';
  };
}
