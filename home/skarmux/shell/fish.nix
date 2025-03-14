{ pkgs, ... }:
{
  programs.fish = {
    plugins = [{
      name = "grc";
      src = pkgs.fishPlugins.grc.src;
    }];
    functions.fish_greeting = ""; # No greeting message
  };
}
