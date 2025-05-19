{
  # The .kdl filetype allows for more configuration options
  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/layouts/default.kdl".text = ''
      layout {
          pane size=1 borderless=true {
              plugin location="tab-bar"
          }
          pane
          pane size=2 borderless=true {
              plugin location="status-bar"
          }
      }
    '';
  };
}
