# { pkgs, ... }:
{
  # home.packages = with pkgs; [ grc ];

  programs.fish = {
    plugins = [
      # { name = "grc"; src = pkgs.fishPlugins.grc.src; } # Auto-color output
    ];
    functions.fish_greeting = ""; # No greeting message
  };
}
