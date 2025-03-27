{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  catppuccin = {
    enable = true; # global
    flavor = "mocha";
    accent = "mauve";
  };
}
