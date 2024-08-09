{ config, pkgs, ... }:
{
  programs.nixvim.plugins = {
      # Neovim native lsp support
      lsp = {
        enable = true;
        inlayHints = true; # since Neovim 0.10.0
        servers = {
          html.enable = true;
          htmx.enable = true;
          # intelephense.enable = true;
          java-language-server.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          nixd.enable = true;
          phpactor.enable = true;
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
    };
  }
