{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # Check crate versions in `Cargo.toml`
      crates.enable = true;

      # Feature package on top of lsp
      # Overview: https://github.com/mrcjkb/rustaceanvim#books-usage--features
      rustaceanvim = {
        enable = true;
        settings = {
          dap.adapter = {
            command = "${pkgs.lldb_19}/bin/lldb-dap";
            type = "executable";
          };
          tools.enable_clippy = true;
          server = {
            default_settings = {
              inlayHints = { lifetimeElisionHints = { enable = "always"; }; };
              rust-analyzer = {
                cargo = { allFeatures = true; };
                check = { command = "clippy"; };
              };
            };
          };
        };
      };

      lsp.servers = {
        rust_analyzer.enable = false;
      };

      dap = {
        enable = true;
        extensions = {
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
        };
        adapters = {
          executables = { lldb = { command = "${pkgs.lldb_19}/bin/lldb-dap"; }; };
        };
      };
    };

    keymaps = [
      # { 
      #   mode = "n"; 
      #   key = "ga";
      #   action = "";
      #   options = {
      #     silent = true;
      #     desc = "Code Action";
      #     script = /* lua */ ''
      #     function() vim.cmd.RustLsp('codeAction') end
      #     '';
      #   };
      # }
      # { 
      #   mode = "n";
      #   key = "gk";
      #   action = "";
      #   options = {
      #     silent = true;
      #     desc = "Hover Action";
      #     script = /* lua */ ''
      #     function() vim.cmd.RustLsp({'hover', 'actions'}) end
      #     '';
      #   };
      # }
      { # Debugger testables
        mode = "n";
        key = "<leader>dt";
        action = "<cmd>lua vim.cmd('RustLsp testables')<CR>";
        options = {
          silent = true;
          desc = "Debugger testables";
        };
      }
    ];
  };
}
