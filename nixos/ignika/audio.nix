{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # uncomment if using jack-applications
    # jack.enable = true;
    wireplumber = {
      # extraConfig.bluetoothEnhancements = {
      #   "monitor.bluez.properties" = {
      #     "bluez5.enable-sbc-xq" = true;
      #     "bluez5.enable-msbc" = true;
      #     "bluez5.enable-hw-volume" = true;
      #     "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      #   };
      # };
    };
  };

  # Desktop
  # environment.systemPackages = with pkgs; [ pavucontrol ];

  # You can control audio using `wpctl` the drop-in replacement for `pactl`
  # Monitor outputs: `pw-top`
  # Select device: `wpctl set-default ID`
  # Set device volume: `wpctl set-volume ID VOL%[+|-]`
}
