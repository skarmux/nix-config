#!/bin/sh
unset LD_PRELOAD
xhost +si:localuser:skarmux
sudo chown -f -R skarmux:users /tmp/.X11-unix
sudo systemctl enable nix-daemon --now
source /etc/profile.d/nix.sh
exec nixGLIntel Hyprland
