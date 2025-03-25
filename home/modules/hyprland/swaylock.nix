{ config, lib, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    # package = swaylock-effects;
    settings = {
      ignore-empty-password = true;
      indicator-radius = 200;
      indicator-thickness = 20;

      # color = "${palette.base00}";
      # inside-color = "${palette.base00}";
      # inside-clear-color = "${palette.base00}";
      # inside-caps-lock-color = "${palette.base00}";
      # inside-ver-color = "${palette.base00}";
      # inside-wrong-color = "${palette.base00}";
      # key-hl-color = "${palette.base0B}";
      # line-color = "${palette.base0B}";
      # line-clear-color = "${palette.base0B}";
      # line-caps-lock-color = "${palette.base0B}";
      # line-ver-color = "${palette.base0B}";
      # line-wrong-color = "${palette.base0B}";
      # ring-color = "${palette.base0B}";
      # separator-color = "${palette.base0B}";
    };
  };
}
