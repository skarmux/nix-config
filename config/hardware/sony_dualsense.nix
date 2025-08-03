{
    home-manager.users.skarmux = {
        wayland.windowManager.hyprland.settings = {
            device = [
                {
                    name = "sony-interactive-entertainment-dualsense-wireless-controller-touchpad";
                    # The touchpad would add unwanted mouse inputs through hyprland when running games.
                    enabled = false;
                }
            ];
        };
    };
}