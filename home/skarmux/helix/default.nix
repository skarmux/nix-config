{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkOption mkMerge types;
  cfg = config.programs.helix;
in
{
  options.programs.helix = {
    tree-file-picker = mkOption {
      type = types.enum [ "zellij" "tmux" "none" ];
      default = "none";
      description = ''
        Use a file tree from within helix and open additional files.
        Only "zellij" supports a floating window.
      '';
    };
  };

  config = mkMerge [
    {
     programs.helix = {

        settings = {

          editor = import ./editor.nix;
      
          # Keymappings
          keys.normal = {
            # Allow `esc` to close multi-cursor mode
            esc = [ "collapse_selection" "keep_primary_selection" ];
          };
        };

        languages = {

          imports = [
            ./rust.nix
          ];

          # HTML
          # language-server.html-language-server = {
          #   command =
          #     "${pkgs.vscode-langservers-extracted}/bin/html-language-server";
          #   args = [ "--stdio" ];
          # };

          # Typst
          # language-server.typst-lsp = {
          #   command = "${pkgs.typst-lsp}/bin/typst-lsp";
          # };

          # PHP
          # language-server.phpactor = {
          #   command = "${pkgs.phpactor}/bin/phpactor";
          #   args = [ "--stdio" ];
          #   config = {
          #     language_server_worse_reflection.inlay_hints = {
          #       enable = true;
          #       types = true;
          #       params = true;
          #     };
          #   };
          # };

          # language specific configuration at ~/helix/languages.toml 
          language = [
            # Typst
            {
              name = "typst";
              file-types = [ "typ" ];
              scope = "source.typst";
              roots = [ ];
              comment-token = "//";
              indent = {
                tab-width = 2;
                unit = " ";
              };
              formatter = {
                command = "${pkgs.typstfmt}/bin/typstfmt";
                args = [ "--output" "-" ];
              };
              auto-format = true;
              language-servers = [ "typst-lsp" ];
            }
            # HTML
            {
              name = "html";
              file-types = [ "html" ];
              indent = {
                tab-width = 4;
                unit = " ";
              };
              language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
              text-width = 100;
              soft-wrap.wrap-at-text-width = true;
            }
            # JavaScript / TypeScript
            {
              name = "typescript";
              file-types = [ "ts" ];
              indent = {
                tab-width = 4;
                unit = " ";
              };
              language-servers = [ "typescript-language-server" ];
              text-width = 100;
              soft-wrap.wrap-at-text-width = true;
            }
          ];

          grammar = [{
            name = "typst";
            source.path = "${pkgs.tree-sitter-grammars.tree-sitter-typst}";
          }];
        };
      };
    }

    (mkIf (cfg.tree-file-picker == "tmux") {
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
        C-y = [ ":sh tmux new-window -n fx '~/.config/helix/yazi-picker.sh open'" ];
      };
    })

    (mkIf (cfg.tree-file-picker == "zellij") {
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
        C-y = [ ":sh zellij run -n Yazi -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh open %{buffer_name}" ];
      };
    })
  ];
}

