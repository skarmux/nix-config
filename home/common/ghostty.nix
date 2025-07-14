{
  programs.ghostty = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    clearDefaultKeybinds = true; # I need ctrl+v for now

    settings = {
      # alpha-blending = "linear-corrected";
      cursor-style = "bar"; # block | bar | underline | block_hollow

      background-blur = false; # blur is done by hyprland

      window-padding-balance = true;
      window-padding-color = "extend-always";
      window-padding-x = 10;
      window-padding-y = 10;

      confirm-close-surface = false;
    };
  };
}
