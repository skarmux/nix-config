{pkgs,...}:
{
  programs.nixvim = {
    plugins = {

      cmp-dap.enable = true;

      dap = {
        enable = true;

        extensions = {
          dap-ui = {
            enable = true;
            floating.mappings.close = ["<ESC>" "q"];
            layouts = [
              {
                elements = [
                  {
                    id = "repl";
                    size = 0.1;
                  }
                  {
                    id = "breakpoints";
                    size = 0.1;
                  }
                  # {
                  #   id = "stacks";
                  #   size = 0.25;
                  # }
                  # {
                  #   id = "watches";
                  #   size = 0.25;
                  # }
                  {
                    id = "scopes";
                    size = 0.8;
                  }
                ];
                position = "right";
                size = 20;
              }
              {
                elements = [
                  {
                    id = "console";
                    size = 0.5;
                  }
                ];
                position = "bottom";
                size = 10;
              }
            ];
          };

          dap-virtual-text.enable = true;
        };

        signs = {
          dapBreakpoint = {
            text = "";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "";
            texthl = "DapBreakpointCondition";
          };
          dapLogPoint = {
            text = "";
            texthl = "DapLogPoint";
          };
        };
      };
    };

    keymaps = [

      {
        mode = "n";
        key = "<leader>dc";
        action = ":DapContinue<cr>";
        options = {
          silent = true;
          desc = "Continue";
        };
      }

      {
        mode = "n";
        key = "<leader>da";
        action = "<cmd>lua require('dap').continue({ before  = get_args })<cr>";
        options = {
          silent = true;
          desc = "Run with Args";
        };
      }

      {
        mode = "n";
        key = "<leader>da";
        action = "<cmd>lua require('dap').run_to_cursor()<cr>";
        options = {
          silent = true;
          desc = "Run to cursor";
        };
      }

      {
        mode = "n";
        key = "<leader>da";
        action = "<cmd>lua require('dap').goto_()<cr>";
        options = {
          silent = true;
          desc = "Go to line (no execute)";
        };
      }

      {
        mode = "n";
        key = "<leader>di";
        action = ":DapStepInto<cr>";
        options = {
          silent = true;
          desc = "Step into";
        };
      }

      {
        mode = "n";
        key = "<leader>dO";
        action = ":DapStepOver<cr>";
        options = {
          silent = true;
          desc = "Step over";
        };
      }

      {
        mode = "n";
        key = "<leader>dk";
        action = ":DapStepOut";
        options = {
          silent = true;
          desc = "Step out";
        };
      }

      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<cr>";
        options = {
          silent = true;
          desc = "Dap UI";
        };
      }


      {
        mode = "n";
        key = "<leader>db";
        action = ":DapToggleBreakpoint<cr>";
        options = {
          silent = true;
          desc = "Breakpoint";
        };
      }

      {
        mode = "n";
        key = "<leader>dB";
        action = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        options = {
          silent = true;
          desc = "Conditional breakpoint";
        };
      }

      {
        mode = "n";
        key = "<leader>de";
        action = "<cmd>lua require'dap'.terminate()<CR>";
        options = {
          silent = true;
          desc = "Reset";
        };
      }

      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require'dap'.run_last()<CR>";
        options = {
          silent = true;
          desc = "Repeat last";
        };
      }
    ];
  };
}
