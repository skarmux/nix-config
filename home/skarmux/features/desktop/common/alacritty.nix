{ pkgs, ... }: {
  home.sessionVariables.TERMINAL = "${pkgs.alacritty}/bin/alacritty";

  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      live_config_reload = false;
      window = {
        dynamic_padding = true;
        padding.x = 15;
      };
      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };
      mouse.hide_when_typing = false;
    };
  };
}
