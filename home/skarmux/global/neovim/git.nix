{
  programs.nixvim = {
    plugins = {
      # Git Integration
      neogit = {
        enable = true;
      };

      # Per line git status symbols in extra column
      gitsigns.enable = true;
    };
  };
}
