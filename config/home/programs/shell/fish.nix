{ pkgs, ... }:
{
  programs.fish = {
    plugins = [{
      # Auto-color output
      name = "grc";
      src = pkgs.fishPlugins.grc.src;
    }];
    functions.fish_greeting = ""; # No greeting message
  };
}
