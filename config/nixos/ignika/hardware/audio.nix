{ pkgs, ... }:
{
  # Recommended by the Wiki on use of PipeWire:
  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber = {
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];
    };
  };

  # Desktop
  # environment.systemPackages = with pkgs; [ pavucontrol ];

  # You can control audio using `wpctl` the drop-in replacement for `pactl`
  # Monitor outputs: `pw-top`
  # Select device: `wpctl set-default ID`
  # Set device volume: `wpctl set-volume ID VOL%[+|-]`
}
