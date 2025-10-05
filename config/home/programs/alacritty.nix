{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "zellij";
        # args = [ "-l" "welcome"];
      };
      general = {
        live_config_reload = false;
      };
      window = {
        dynamic_padding = true;
        padding = { x = 15; y = 15; };
        blur = false; # Done by hyprland
      };
      cursor = {
        # style = { <shape>, <blinking> };
        style = {
          shape = "Block"; # Block | Underline | Beam
          blinking = "On";
        };
        unfocused_hollow = true;
      };
      selection = {
        save_to_clipboard = true;
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
