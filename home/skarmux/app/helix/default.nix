{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    # configuration written to ~/helix/config.toml
    settings = {
      editor = import ./editor.nix;
      keys.normal = {
        # Allow `esc` to close multiple cursors
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

  # xdg.desktopEntries.helix = {
  #   name = "Helix";
  #   genericName = "Text Editor";
  #   comment = "Edit text files";
  #   exec = "hx %F";
  #   icon = "helix";
  #   mimeType = [ "text/plain" "text/x-java" "application/x-shellscript" ];
  #   terminal = true;
  #   type = "Application";
  #   categories = [ "Utility" "TextEditor" ];
  # };
}

