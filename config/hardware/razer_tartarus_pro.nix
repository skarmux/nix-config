{
  # TODO: Open Razer does not support Tartarus Pro yet
  # environment.systemPackages = with pkgs; [
  #   openrazer-daemon
  # ];

  # FIXME: Make this available in home-manger-only environments!
  home-manager.users.skarmux = {
    # Setting the layout to US international, allowing €äüöß without any dead-keys
    wayland.windowManager.hyprland.settings = {
      device = [
        {
          name = "razer-razer-tartarus-pro";
        }
        {
          name = "razer-razer-tartarus-pro-keyboard";
          kb_layout = "us";
          kb_variant = "";
          keybinds = false;
        }
      ];
    };
  };

}