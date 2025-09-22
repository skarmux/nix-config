{ pkgs, config, ... }:
#
# nix shell nixpkgs#usbutils
# lsusb | rg sony
# Bus 003 Device 004: ID 054c:0ce6 Sony Corp. DualSense wireless controller (PS5)
#
let
  # Run `hyprctl devices` for a list of plugged in device names
  touchpad_name = "sony-interactive-entertainment-dualsense-wireless-controller-touchpad";

  # Disable the touchpad in hyprland when a game window is focused
  # touchpad_auto_toggle = pkgs.writeShellApplication {
  #   name = "sony-dualsense-touchpad-auto-toggle";
  #   runtimeInputs = [
  #     config.programs.hyprland.package
  #     pkgs.socat
  #   ];
  #   text = ''
  #     SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  #     DEVICE="${touchpad_name}"

  #     socat - UNIX-CONNECT:"$SOCK" | while read -r line; do
  #       if [[ "$line" == activewindow* ]]; then
  #         if [[ "$line" == *"steam_app_"* ]] || [[ "$line" == *"gamescope"* ]]; then
  #           hyprctl keyword input:$DEVICE:enabled false
  #         else
  #           hyprctl keyword input:$DEVICE:enabled true
  #         fi
  #       fi
  #     done
  #   '';
  # };
in
{
  home-manager.users.skarmux = {
    wayland.windowManager.hyprland.settings = {
      device = [{
        name = "${touchpad_name}";
        enabled = false;
      }];
    };
  };

  # systemd.user.services = {
  #   hypr-dualsense-touchpad-auto-toggle = {
  #     description = "Disable DualSense touchpad when a game window is focused";
  #     after = [ "graphical-session.target" "hyprland-session.target" ];
  #     bindsTo = [ "graphical-session.target" ];

  #     serviceConfig = {
  #       ExecStart = "${touchpad_auto_toggle}";
  #       Restart = "always";
  #     };

  #     wantedBy = [ "default.target" ];
  #   };
  # };

  # services.udev.extraRules = /* udev */ ''
  #   # DualSense (replace IDs with yours from lsusb / udevadm info)
  #   ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", \
  #     TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="hypr-dualsense-touchpad-auto-toggle.service"

  #   ACTION=="remove", SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", \
  #     TAG+="systemd", ENV{SYSTEMD_USER_WANTS}-="hypr-dualsense-touchpad-auto-toggle.service"
  # '';
}