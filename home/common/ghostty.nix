{
  programs.ghostty = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    # clearDefaultKeybinds = true; # I need ctr+v for now
    settings = {
      font-family = "FiraCode Nerd Font Propo";
      font-style-bold = "Bold";
      font-synthetic-style = false;
      font-size = 20;
      alpha-blending = "linear-corrected";
      cursor-style = "block_hollow";
      # FIXME: Ghostty crashes when images with alpha channels
      #        are being displayed with yazi
      background-opacity = 0.8;
      background-blur = false;
      window-padding-balance = true;
      window-padding-color = "extend-always";
      confirm-close-surface = false;
      # NOTE: Not working right now. The `global:` keyword is
      #       only supported on macOS. Is it even useful without
      #       global accessibiliy?
      # quick-terminal-position = "center";
      # quick-terminal-screen = "mouse";
      # keybind = [
      #   "super+t=toggle_quick_terminal"
      # ];
    };
  };
}
