{ config
, lib
, default ? false
, ...
}:
{
  home.sessionVariables.TERMINAL = lib.mkIf default "${config.programs.alacritty.package}/bin/alacritty";

  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false; # are we even nix, bro?
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
