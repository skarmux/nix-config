{ pkgs, config, lib, ... }:
let
  zjstatus = lib.strings.removeSuffix "\n" ''
    default_tab_template {
      children
      pane size=1 borderless=true {
        plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
          format_left   "{mode} #[fg=#89B4FA,bold]{session} {tabs}"
          format_center ""
          format_right  "{command_git_branch} {datetime}"
          format_space  ""

          border_enabled  "false"
          border_char     "─"
          border_format   "#[fg=#6C7086]{char}"
          border_position "top"

          hide_frame_for_single_pane "true"

          mode_normal  "#[bg=blue] "
          mode_tmux    "#[bg=#ffc387] "

          tab_normal   "#[fg=#6C7086] {name} "
          tab_active   "#[fg=#9399B2,bold,italic] {name} "

          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
          command_git_branch_format      "#[fg=blue] {stdout} "
          command_git_branch_interval    "10"
          command_git_branch_rendermode  "static"

          datetime        "#[fg=#6C7086,bold] {format} "
          datetime_format "%A, %d %b %Y %H:%M"
          datetime_timezone "Europe/Berlin"
        }
      }
    }
  '';
in
{
  programs.zellij = {
    attachExistingSession = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableZshIntegration = false;
    exitShellOnExit = false;
    settings = {
      on_force_close = "detach"; # detach | quit
      simplified_ui = true;
      # default_shell = "$SHELL";
      pane_frames = false;
      # theme = "default"; # Manged by Stylix
      default_layout = "default";
      # Switch modes with `Ctrl+G`
      default_mode = "locked"; # locked | normal
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
      # copy_clipboard = "system"; # Does not apply when using copy_command
      copy_on_select = true;
      # scrollback_editor = "$EDITOR";
      mirror_session = true;
      layout_dir = "${config.home.homeDirectory}/.config/zellij/layouts";
      # theme_dir
      # rounded_corners
      # ...
      session_serialization = true;
      pane_viewport_serialization = false;
      # ...
      show_startup_tips = false;
      show_release_notes = false;
      web_server = false; # TODO: Read into it.
      advanced_mouse_actions = true;
    };
    # themes = {};
  };

  home.file = {
    ".config/zellij/layouts/default.kdl".text = ''
      layout {
        ${lib.replaceStrings ["\n"] ["\n  "] zjstatus}
      }
    '';
    ".config/zellij/layouts/sjc.kdl".text = ''
      layout {
        cwd "/home/skarmux/Documents/hzhg/sjc"
        ${lib.replaceStrings ["\n"] ["\n  "] zjstatus}
        tab name="src" {
          pane command="nix" {
            args "develop" "--command" "bash" "-c" "hx src/main.rs"
          }
        }
        tab name="dx" focus=true {
          pane command="nix" {
            args "develop" "--command" "bash" "-c" "dx serve --platform web"
          }
        }
        tab name="css" {
          pane command="nix" {
            args "develop" "--command" "bash" "-c" "tailwindcss -i tailwindcss/input.css -c tailwindcss/tailwind.config.js -o assets/tailwind.css"
          }
        }
      }
    '';
  };
}
