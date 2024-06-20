{
  services.syncthing = {
    enable = true;
    user = "skarmux";
    dataDir = "/home/skarmux/Documents";
    configDir = "/home/skarmux/Documents/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
  };
}
