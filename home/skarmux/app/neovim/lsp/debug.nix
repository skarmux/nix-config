{
  programs.nixvim = {
    
    # Debugging interface (is it though?)
    plugins.dap.enable = true;
    
    keymaps = [
      { # Continue
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua require'dap'.continue()<CR>";
        options = {
          silent = true;
          desc = "Debugger continue";
        };
      }
      { # Step Into
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require'dap'.step_into()<CR>";
        options = {
          silent = true;
          desc = "Debugger step into";
        };
      }
      { # Step Over
        mode = "n";
        key = "<leader>dj";
        action = "<cmd>lua require'dap'.step_over()<CR>";
        options = {
          silent = true;
          desc = "Debugger step over";
        };
      }
      { # Step Out
        mode = "n";
        key = "<leader>dk";
        action = "<cmd>lua require'dap'.step_out()<CR>";
        options = {
          silent = true;
          desc = "Debugger step out";
        };
      }
      { # Toggle breakpoint
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require'dap'.toggle_breakpoint()<CR>";
        options = {
          silent = true;
          desc = "Debugger toggle breakpoint";
        };
      }
      { # Toggle conditional breakpoint
        mode = "n";
        key = "<leader>dd";
        action = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        options = {
          silent = true;
          desc = "Debugger set conditional breakpoint";
        };
      }
      { # Debugger reset
        mode = "n";
        key = "<leader>de";
        action = "<cmd>lua require'dap'.terminate()<CR>";
        options = {
          silent = true;
          desc = "Debugger reset";
        };
      }
      { # Debugger repeat last
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require'dap'.run_last()<CR>";
        options = {
          silent = true;
          desc = "Debugger repeat last";
        };
      }
    ];
  };
}
