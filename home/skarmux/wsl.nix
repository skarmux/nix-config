{
  imports = [
    ./global
    # ./app/neovim
    # ./app/helix
  ];

  xdg.userDirs.createDirectories = false;

  programs.bash.sessionVariables.COLORTERM = "truecolor";
}
