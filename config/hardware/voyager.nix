{ pkgs, lib, ... }:
{
  hardware.keyboard.zsa.enable = true;

  # Kontroll demonstates how to control the Keymapp API, making it easy to control your ZSA keyboard from the command line and scripts.
  #
  # Usage: kontroll <COMMAND>
  #
  # Commands:
  #   list                 List all available keyboards
  #   connect              Connect to a keyboard given the index returned by the list command
  #   connect-any          Connect to the first keyboard detected by keymapp
  #   set-layer            Set the layer of the currently connected keyboard
  #   set-rgb              Sets the RGB color of a LED
  #   set-rgb-all          Sets the RGB color of all LEDs
  #   restore-rgb-leds     Restores the RGB color of all LEDs to their default
  #   set-status-led       Set / Unset a status LED
  #   restore-status-leds  Restores the status of all status LEDs to their default
  #   increase-brightness  Increase the brightness of the keyboard's LEDs
  #   decrease-brightness  Decrease the brightness of the keyboard's LEDs
  #   disconnect           Disconnect from the currently connected keyboard
  #   help                 Print this message or the help of the given subcommand(s)
  #
  # Options:
  #   -h, --help     Print help
  #   -V, --version  Print version

  environment.systemPackages = with pkgs; [
    # TODO: Do I need to launch it for the unix socket to be open to receive api commands via
    #       `kontroll`? I can set it to launch minimized...
    keymapp
    kontroll
  ];

  # FIXME: Make this available in home-manger-only environments!
  home-manager.users.skarmux = {
    # Setting the layout to US international, allowing €äüöß without any dead-keys
    wayland.windowManager.hyprland.settings = {
      device = [{
          name = "zsa-technology-labs-voyager";
          kb_layout = "us";
          kb_variant = "altgr-intl";
      }];

      exec-once = [ "keymapp" ];
    };
    
    systemd.user.services = {

      # kontroll-test = {
      #   Unit = {
      #     Description = "Test kontroll interface to keymapp.";
      #     Requires = [ "keymapp.service" ];
      #     After = [ "keymapp.service" ];
      #   };
      #   Install = {
      #     WantedBy = [ "default.target" ];
      #   };
      #   Service = {
      #     ExecStart = (pkgs.writeShellApplication {
      #       name = "kontroll-test";
      #       runtimeInputs = with pkgs; [ kontroll ];
      #       text = ''
      #         LAYER_MAIN = 0
      #         LAYER_SYM = 1
      #         LAYER_NUM = 2
      #         LAYER_GAME = 3
      #         handle_hyprland_event() {
      #           EVENT="''${$1%%>>*}"
      #           case "$EVENT" in
      #             activewindow)
      #               DATA="''${$1#*>>}"
      #               case "$DATA" in
      #                 Minecraft*)
      #                   kontroll set-layer $LAYER_GAME
      #                 ;;
      #               esac
      #               # WINDOWCLASS="''${$DATA%%,*>>}"
      #               # WINDOWTITLE="''${$DATA#*,>>}"
      #             ;;
      #             # activewindowv2)
      #             #   WINDOWADDRESS="''${$1#*>>}"
      #             # ;;
      #           esac
      #         }
      #         ensure_keyboard_connection() {
      #           # Give a few attempts to check for connection
      #           for i in {1..3}; do
      #             if kontroll list 2>/dev/null | grep -q "(connected)"; then
      #               return 0
      #             elif [ $i -lt 3 ]; then
      #               sleep 1
      #             fi
      #           done
      #           echo "Could not connect to keyboard. Is it plugged in?"
      #           return 1
      #         }
      #         ensure_keyboard_connection
      #         socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle_hyprland_event "$line"; done
      #       '';
      #     }).path;
      #   };
      # }; # kontroll-test.service

    };

  };

}