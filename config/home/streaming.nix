{ pkgs, ... }:
{
    home.packages = with pkgs; [
        obs-studio
        twitch-tui
        ffmpeg-full
        handbrake
    ];

    wayland.windowManager.hyprland.settings = {
        windowrule = [
            "noscreenshare 1, class:^${pkgs.lib.concatStringsSep "|" [
              # Secrets
              "(org.keepassxc.KeePassXC)"
              # Browser
              "(brave-browser)"
              "(firefox)"
              # Messenger
              "(discord)"
              "(Signal)"
              "(org.telegram.desktop)"
              "(Element)"
              # System
              "(org.gnome.Nautilus)"
            ]}$"
        ];
    };
}