#!/bin/sh
unset LD_PRELOAD
xhost +si:localuser:$USER
sudo chown -f -R $USER:$USER /tmp/.X11-unix
source /etc/profile.d/nix.sh
exec nixGLIntel Hyprland
