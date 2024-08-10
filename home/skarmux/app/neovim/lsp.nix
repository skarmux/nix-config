{
  programs.nixvim.plugins = {
      lsp = {
        enable = true;
        inlayHints = true; # since Neovim 0.10.0
        keymaps = {
          lspBuf = {
            gd = "definition";
            gD = "references";
            gi = "implementation";
            gt = "type_definition";
            gh = "hover";
            gca = "code_action";
            gH = "signature_help";
          };
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
        };
        servers = {
          html.enable = true;
          htmx.enable = true;
        java-language-server.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        nixd.enable = true;

        # PHP
        phpactor.enable = true;
        # intelephense.enable = true;

        pylsp.enable = true;
        sqls.enable = true;
        tailwindcss.enable = true;
      };
    };

    # Disabled for now to not mess up git commits accidentally.
    lsp-format.enable = false;

    # Render diagnostics results inline
    lsp-lines = {
      enable = true;
      currentLine = true;
    };

    # LSP process status messages
    fidget.enable = true;
    lsp-status.enable = false;

    lspsaga = {
      enable = true;
      beacon.enable = true;
    };
  };
}
