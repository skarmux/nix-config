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

  programs.fish.shellInit = /* fish */ ''
    if not set -q TMUX
        set -g TMUX tmux new-session -d -s base
        eval $TMUX
        tmux attach-session -d -t base
    end
  '';

  programs.bash.bashrcExtra = /* bash */ ''
    # Start up tmux with shell session: https://unix.stackexchange.com/a/113768
    # Placing in bashrcExtra instead of initExtra to make sure tmux is started before aliases are declared.
    # There is still a check in place to ensure it is running in an interactive shell.
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      exec tmux
    fi
  '';
}
