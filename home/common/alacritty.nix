{
  programs.alacritty = {
    settings = {
      general = {
        live_config_reload = false; # are we even nix, bro?
      };
      window = {
        dynamic_padding = true;
        padding = { x = 15; };
        blur = false; # Done by hyprland
      };
      cursor = {
        style = "Beam"; # Block | Underline | Beam
        # unfocused_hollow = true;
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
