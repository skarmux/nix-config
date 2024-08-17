{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    disableConfirmationPrompt = true;
    clock24 = true;
  };
}
