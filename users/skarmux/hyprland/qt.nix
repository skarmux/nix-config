{ pkgs, lib, ... }: {
  qt = {
    enable = lib.mkDefault true;
    platformTheme = { name = "gtk"; };
    style = {
      name = "gtk2";
      package = pkgs.qt6Packages.qt6gtk2;
    };
  };
}
