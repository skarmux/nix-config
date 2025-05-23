{
  programs.bash = {
    enable = true;
    bashrcExtra = /* bash */ ''
      # Start up tmux with shell session: https://unix.stackexchange.com/a/113768
      # Placing in bashrcExtra instead of initExtra to make sure tmux is started before aliases are declared.
      # There is still a check in place to ensure it is running in an interactive shell.
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';
  };
}
