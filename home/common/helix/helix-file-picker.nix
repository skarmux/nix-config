{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkMerge types;
  cfg = config.programs.helix;
in
{
  options.programs.helix = {
    file-picker = mkOption {
      type = types.enum [ "zellij" "tmux" "none" ];
      default = "none";
      description = /* text */ ''
        Use a file tree from within helix and open additional files.
        Only zellij supports floating windows.
        Does install yazi with tmux or zellij respectively.
      '';
    };
  };

  config = mkMerge [

    (mkIf (cfg.file-picker == "tmux") {
      # File tree picker in Helix with tmux
      # https://yazi-rs.github.io/docs/tips/#helix-with-tmux

      programs.yazi.enable = true;
      programs.tmux.enable = true;

      home.file.".config/helix/yazi-picker.sh" = {
        text = ''
          #!/usr/bin/env bash
          paths=$(yazi --chooser-file=/dev/stdout)
          if [[ -n "$paths" ]]; then
            tmux last-window
            tmux send-keys Escape
            tmux send-keys ":$1 $paths"
            tmux send-keys Enter
          else
            tmux kill-window -t fx
          fi
        '';
        executable = true;
      };

      programs.helix.settings.keys.normal = {
        C-y = ":sh tmux new-window -n fx '~/.config/helix/yazi-picker.sh open'";
      };
    })


    (mkIf (cfg.file-picker == "zellij") {
      # File tree picker in Helix with zellij
      # https://yazi-rs.github.io/docs/tips/#helix-with-zellij

      programs.yazi.enable = true;
      programs.zellij.enable = true;

      home.file.".config/helix/yazi-picker.sh" = {
        text = ''
          #!/usr/bin/env bash
          paths=$(yazi "$2" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)
          if [[ -n "$paths" ]]; then
            zellij action toggle-floating-panes
            zellij action write 27 # send <Escape> key
            zellij action write-chars ":$1 $paths"
            zellij action write 13 # send <Enter> key
          else
            zellij action toggle-floating-panes
          fi
        '';
        executable = true;
      };

      programs.helix.settings.keys.normal = {
        C-y = ":sh zellij run -n Yazi -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh open %{buffer_name}";
      };
    })

  ];
}
