{ config, pkgs, lib, ... }:
let inherit (config.colorscheme) palette;
in {
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "shutdown"; # CSS class
        action = "systemctl poweroff";
        text = "";
        keybind = "s";
        # circular = true;
      }
      {
        label = "reboot"; # CSS class
        action = "systemctl reboot";
        text = "";
        keybind = "r";
        # circular = true;
      }
    ] ++ (lib.optionals config.programs.swaylock.enable [{
      label = "lock"; # CSS class
      action = "${pkgs.hyprlock}/bin/hyprlock";
      text = "";
      keybind = "l";
      # circular = true;
    }]);

    style = # css
      ''
        * {
          background-image: none;
          box-shadow: none;
        }

        window {
          background-color: rgba(12, 12, 12, 0.8);
        }

        button {
          color: #${palette.base05};
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/lock.png"));
        }

        #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/logout.png"));
        }

        #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"),
          url("${pkgs.wlogout}/local/share/wlogout/icons/reboot.png"));
        }
      '';
  };
}
