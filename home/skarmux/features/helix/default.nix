{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    catppuccin = {
      enable = true;
      useItalics = true;
    };

    # configuration written to ~/helix/config.toml
    settings = {

      editor = {
        scrolloff = 8;
        mouse = true;
        middle-click-paste = true;
        scroll-lines = 3;
        shell = [ "sh" "-c" ];
        line-number = "relative";
        cursorline = false; # TODO: true if no transparency
        cursorcolumn = false;
        auto-completion = true;
        auto-format = true;
        auto-save = false;
        idle-timeout = 0;
        preview-completion-insert = true;
        completion-trigger-len = 1;
        completion-replace = true;
        auto-info = true;
        true-color = false; # keep using auto detection
        undercurl = false;
        rulers = [ ];
        bufferline = "never"; # always | never | multiple
        color-modes = false;
        text-width = 120;
        default-line-ending = "lf";
        insert-final-newline = true;
      };

      editor.statusline = {
        left = [ "mode" "diagnostics" "spinner" ];
        center =
          [ "file-name" "read-only-indicator" "file-modification-indicator" ];
        right = [
          "version-control"
          "selections"
          "register"
          "file-encoding"
          "position"
        ];
        separator = "|";
        mode.normal = "";
        mode.insert = "󰌌";
        mode.select = "󰇀";
      };

      editor.lsp = {
        display-messages = false;
        auto-signature-help = true;
        display-inlay-hints = true;
        display-signature-help-docs = true;
        snippets = true;
        goto-reference-include-declaration = true;
      };

      editor.cursor-shape = {
        insert = "block";
        normal = "block";
        select = "block";
      };

      editor.file-picker = {
        hidden = false;
        follow-symlinks = true;
        deduplicate-links = true;
        parents = true;
        ignore = true;
        git-ignore = true;
        git-global = false;
        git-exclude = false;
        #max-depth = None;
      };

      editor.search = {
        smart-case = true;
        wrap-around = true;
      };

      editor.whitespace = {
        render = {
          tab = "all";
          nbsp = "all";
        };
        characters.tab = "→";
        characters.tabpad = "·";
        characters.nbsp = "⍽";
      };

      editor.indent-guides = {
        render = true;
        character = "│"; # Some characters that work well: "▏", "┆", "┊", "⸽"
        skip-levels = 0;
      };

      editor.gutters = {
        layout = [ "diagnostics" "spacer" "line-numbers" "spacer" "diff" ];
        line-numbers.min-width = 2;
      };

      editor.smart-tab = {
        enable = true;
        supersede-menu = false;
      };

      keys.normal = {
        # Leader key shortcuts
        space.w = ":wa";
        space.q = ":q";
        space.c = ":bc";

        # Allow `esc` to close multiple cursors
        esc = [ "collapse_selection" "keep_primary_selection" ];

        C-v = ":vs";
        C-h = ":hs";
      };

      # Unlearning those keys
      keys.insert = {
        up = "no_op";
        down = "no_op";
        left = "move_char_left";
        right = "move_char_right";
        pageup = "no_op";
        pagedown = "no_op";
        home = "no_op";
        end = "no_op";
      };
    };

    languages = {

      language-server.rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        # LSP srashes in Direnv when enabled
        # args = ["--stdio"];
      };

      language-server.html-language-server = {
        command =
          "${pkgs.vscode-langservers-extracted}/bin/html-language-server";
        args = [ "--stdio" ];
      };

      language-server.typst-lsp = {
        command = "${pkgs.typst-lsp}/bin/typst-lsp";
      };

      language-server.phpactor = {
        command = "${pkgs.phpactor}/bin/phpactor";
        args = [ "--stdio" ];
        config = {
          language_server_worse_reflection.inlay_hints = {
            enable = true;
            types = true;
            params = true;
          };
        };
      };

      # language specific configuration at ~/helix/languages.toml 
      language = [
        {
          name = "rust";
          file-types = [ "rs" ];
          indent = {
            tab-width = 4;
            unit = " ";
          };
          formatter = { command = "${pkgs.rustfmt}/bin/rustfmt"; };
          text-width = 100;
          auto-format = true;
        }
        {
          name = "toml";
          file-types = [ "toml" ];
          indent = {
            tab-width = 4;
            unit = " ";
          };
          text-width = 100;
          auto-format = true;
        }
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
      ];

      grammar = [{
        name = "typst";
        source.path = "${pkgs.tree-sitter-grammars.tree-sitter-typst}";
      }];
    };

  };

  xdg.desktopEntries.helix = {
    name = "Helix";
    genericName = "Text Editor";
    comment = "Edit text files";
    exec = "hx %F";
    icon = "helix";
    mimeType = [ "text/plain" "text/x-java" "application/x-shellscript" ];
    terminal = true;
    type = "Application";
    categories = [ "Utility" "TextEditor" ];
  };
}

