{ config, lib, ... }: {
  programs.hyprlock = let
    primary = (builtins.elemAt (lib.filter (m: m.primary) config.monitors) 0);
  in {
    enable = true;
    backgrounds = [{
      monitor = primary.name;
      path = ".wallpaper/nix-magenta-blue-1920x1080.png";
      blur_passes = 2;
    }];
    labels = [{
      monitor = primary.name;
      text = "";
    }];
  };
}
