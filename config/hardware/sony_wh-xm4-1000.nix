{
  services.pipewire.wireplumber.extraConfig = {

    # TODO: Disable/Hide handsfree modes/devices completely
    "wh-1000xm4" = {
      # "monitor.bluez.rules" = [
      #   {
      #     matches = [
      #       {
      #         "device.name" = "-bluez_card.*";
      #         "device.product.id" = "";
      #         "device.vendor.id" = "";
      #       }
      #     ];
      #     actions = {
      #       update-props = {
      #         "bluez5.a2dp.ldac.quality" = "hq";
      #       };
      #     };
      #   }
      # ];
    };

  };
}