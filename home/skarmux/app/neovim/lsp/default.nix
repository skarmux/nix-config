{
  imports = [
    ./debug.nix
    ./rust.nix
  ];

  programs.nixvim = {
    diagnostics.virtual_lines.only_current_line = true;

    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          jsonls.enable = true;
          lua_ls.enable = true;
          marksman.enable = true;
          nixd.enable = true;

        # html.enable = true;
        # htmx.enable = true;

        # phpactor.enable = true;
        # intelephense.enable = true;

        # pylsp.enable = true;
        # sqls.enable = true;
        # tailwindcss.enable = true;
      };

      keymaps = {
        # Mappings for `vim.lsp.buf.<action>` functions
        # to be added when an LSP is attached.
        lspBuf = {
          gd = "definition";
          gr = "references";
          gi = "implementation";
          gt = "type_definition";
          gk = "hover";
          ga = "code_action";
          gh = "signature_help";
        };

        # Mappings for `vim.diagnostic.<action>` functions
        # to be added when an LSP is attached.
        diagnostic = {
          "<leader>l" = "goto_next";
          "<leader>h" = "goto_prev";
        };

        extra = [
          {
            action = "<CMD>LspStop<Enter>";
            key = "<leader>lx";
          }
          {
            action = "<CMD>LspStart<Enter>";
            key = "<leader>ls";
          }
          {
            action = "<CMD>LspRestart<Enter>";
            key = "<leader>lr";
          }
        ];
      };
    };

    # Disabled for now to not mess up git commits accidentally.
    lsp-format.enable = false;

    # Render diagnostics results inline
    # lsp-lines = {
    #   enable = true;
    #   currentLine = true;
    # };

    # LSP process status messages
    fidget.enable = true;
    lsp-status.enable = false;

    # lspsaga = {
    #   enable = true;
    #   beacon.enable = true;
    # };
  };
};
}
