{ ... }: {
  programs.fish = {
    enable = true;
    # catppuccin.enable = true;
    vendor = {
      functions.enable = true;
      config.enable = true;
      completions.enable = true;
    };
  };
}
