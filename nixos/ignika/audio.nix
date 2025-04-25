{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services = {
    # pulseaudio = {
    #   enable = false;
    # };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };
  };

  # Desktop
  environment.systemPackages = with pkgs; [ pavucontrol ];

  # You can control audio using `wpctl` the drop-in replacement for `pactl`
  # Monitor outputs: `pw-top`
  # Select device: `wpctl set-default ID`
  # Set device volume: `wpctl set-volume ID VOL%[+|-]`
}
