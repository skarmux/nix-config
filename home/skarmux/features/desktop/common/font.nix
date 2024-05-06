{ pkgs, ... }: {
  fontProfiles = {
    enable = true;

    monospace = {
      family = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };

    regular = {
      family = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
    };

    emoji = {
      family = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji;
    };

  };
}
