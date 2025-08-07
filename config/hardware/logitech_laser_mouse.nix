{
    # Mouse at 28e82d70:
    #   logitech-usb-laser-mouse
    #     default speed: 0.00000

    # Mouse key codes can be captured with `wev`

    home-manager.users.skarmux = {
        wayland.windowManager.hyprland.settings = {
            "$mouse_left" = "mouse:272";
            "$mouse_right" = "mouse:273";
            "$mouse_middle" = "mouse:274";
            "$mouse_backward" = "mouse:275";
            "$mouse_forward" = "mouse:276";
        };
    };
}