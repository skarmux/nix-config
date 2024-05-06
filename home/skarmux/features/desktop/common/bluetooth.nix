{ ... }: {
  # Whether to enable a proxy forwarding Bluetooth
  # MIDI controls via MPRIS2 to control media players.
  services.mpris-proxy.enable = true;

  services.blueman-applet.enable = true;
}
