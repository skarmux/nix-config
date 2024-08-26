{
  imports = [
    ./global
    ./app/neovim
    ./app/syncthing.nix
  ];

  xdg.userDirs.createDirectories = false;
}
