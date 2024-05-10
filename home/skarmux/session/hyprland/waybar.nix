{ pkgs, config, lib, ... }:
{
  programs.waybar = {
    enable = lib.mkDefault true;
    systemd.enable = true;

    settings.primary = let
      jq = "${pkgs.jq}/bin/jq";
      cut = "${pkgs.coreutils}/bin/cut";
      wc = "${pkgs.coreutils}/bin/wc";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      playerctld = "${pkgs.playerctl}/bin/playerctld";
      # Function to simplify making waybar outputs
      jsonOutput = name:
        { pre ? "", text ? "", tooltip ? "", alt ? "", class ? ""
        , percentage ? "" }:
        "${
          pkgs.writeShellScriptBin "waybar-${name}" ''
            set -euo pipefail
            ${pre}
            ${jq} -cn \
              --arg text "${text}" \
              --arg tooltip "${tooltip}" \
              --arg alt "${alt}" \
              --arg class "${class}" \
              --arg percentage "${percentage}" \
              '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
          ''
        }/bin/waybar-${name}";
    in {
      layer = "top";
      height = 30;
      margin = "0";
      position = "top";

      modules-left = [ "custom-menu" ]
        ++ (lib.optionals config.wayland.windowManager.hyprland.enable [
          "hyprland/workspaces"
          "hyprland/submap"
        ]) ++ [ "custom/currentplayer" "custom/player" ];

      modules-center = [
        "clock"
        # "custom/unread-mail"
        # "custom/gpg-agent"
      ];

      modules-right = [
        # "custom/tailscale-ping"
        "tray"
        "cpu"
        "memory"
        "pulseaudio"
        "network"
        "battery"
        # "custom/hostname"
      ];

      clock = {
        interval = 1;
        format = "{:%H:%M:%S}";
        tooltip-format = ''
          {:%d.%m.%y}         
        '';
      };

      battery = {
        bat = lib.mkDefault "BAT0";
        interval = 120;
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        format = "{icon}";
        format-charging = "󰂄";
        onclick = "";
        bat-compatibility = true;
        tooltip-format = "{capacity}%";
      };

      cpu = { format = "  {usage}%"; };

      memory = {
        format = "  {}%";
        interval = 5;
      };

      "custom/hostname" = {
        exec = "echo $USER@$HOSTNAME";
        on-click = "${pkgs.systemd}/bin/systemctl --user restart waybar";
      };

      pulseaudio = {
        format = "{icon}";
        format-muted = " ";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          portable = "";
          default = [ "" "" "" ];
        };
        tooltip-format = "{volume}%";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };

      network = {
        interval = 3;
        format-wifi = "  {essid}";
        format-ethernet = "󰈀";
        format-disconnected = "";
        tooltip-format = ''
          {ifname}
          {ipaddr}/{cidr}
          Up: {bandwidthUpBits}
          Down: {bandwidthDownBits}'';
        on-click = "";
      };

      "hyprland/workspaces" = {
        format = "{windows}";
        window-rewrite-default = "";
        window-rewrite = {
          "title<.*youtube.*>" = "";
          "class<firefox>" = "";
          "class<firefox> title<.*github.*>" = "";
          "class<firefox> title<.*discord.*>" = "󰙯";
          "kitty" = "";
          "code" = "󰨞";
          "helix" = "󰚄";
          "thunar" = "󰉋";
          "steam" = "";
        };
      };

      "custom/currentplayer" = {
        interval = 2;
        return-type = "json";
        exec = jsonOutput "currentplayer" {
          pre = ''
            player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
            count="$(${playerctl} -l 2>/dev/null | ${wc} -l)"
            if ((count > 1)); then
              more=" +$((count - 1))"
            else
              more=""
            fi
          '';
          alt = "$player";
          tooltip = "$player ($count available)";
          text = "$more";
        };
        format = "{icon}{}";
        format-icons = {
          "No player active" = ""; #" ";
          "Celluloid" = "󰎁 ";
          "spotify" = "󰓇 ";
          "ncspot" = "󰓇 ";
          "qutebrowser" = "󰖟 ";
          "firefox" = " ";
          "discord" = " 󰙯 ";
          "sublimemusic" = " ";
          "kdeconnect" = "󰄡 ";
          "chromium" = " ";
        };
        on-click = "${playerctld} shift";
        on-click-right = "${playerctld} unshift";
      };
      "custom/player" = {
        exec-if = "${playerctl} status 2>/dev/null";
        exec = ''
          ${playerctl} metadata --format '{"text": "{{title}} - {{artist}}", "alt": "{{status}}", "tooltip": "{{title}} - {{artist}} ({{album}})"}' 2>/dev/null '';
        return-type = "json";
        interval = 2;
        max-length = 30;
        format = "{icon} {}";
        format-icons = {
          "Playing" = "󰐊";
          "Paused" = "󰏤 ";
          "Stopped" = "󰓛";
        };
        on-click = "${playerctl} play-pause";
      };
    };

    style = /* css */ ''
      * {
        font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
        font-size: 12pt;
        padding: 0;
        margin: 0 0.4em;
      }

      window#waybar {
        padding: 0;
      }

      .modules-left {
        margin-left: -1.0em;
      }

      #workspaces button {
        padding: 0 0.3em;
      }
      #workspaces button.hidden {
      }
      #workspaces button.visible {
      }
      #workspaces button.active {
      }

      #clock {
        padding-right: 1em;
        padding-left: 1em;
      }

      #custom-menu {
        padding-right: 1.5em;
        padding-left: 1em;
        margin-right: 0;
        border-radius: 0.5em;
      }
      #custom-menu.fullscreen {
      }
      #custom-hostname {
      }
      #custom-currentplayer {
        padding-right: 0;
      }
      #tray {
      }
      #cpu, #memory {
      } 
    '';
  };
}
