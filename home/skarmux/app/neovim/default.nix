{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./completion
    ./ollama
    ./rust
    ./git.nix
    ./typst.nix
    # ./obsidian.nix
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavor = config.catppuccin.flavor;
    };

    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      cursorline = false;
      guicursor = "v-n-c-i:block-Cursor";
      softtabstop = 4;
      expandtab = true;
      autoindent = true;
      shiftwidth = 4; # Tab width should be 4
      tabstop = 4;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      foldlevelstart = 99;
    };

    globals = { mapleader = " "; };

    extraPlugins = with pkgs.vimPlugins; [
      pretty-fold-nvim
    ];

    extraConfigLua = # lua
    ''
    require('pretty-fold').setup()
    '';

    plugins = {
      # Fuzzy file finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          undo.enable = true;
        };
        keymaps = {
          # Search files
          "<leader>f" = {
            action = "find_files";
            options = { desc = "Telescope Find Files"; };
          };
          # Search keyword in project
          "<leader>p" = {
            action = "live_grep";
            options = { desc = "Telescope Find Files"; };
          };
          # Show open buffers
          "<leader>b" = {
            action = "buffers";
            options = {
                desc = "Telescope Buffers"; 
            };
          };
          # Search git tracked files
          "<C-g>" = {
            action = "git_files";
            options = { desc = "Telescope Git Files"; };
          };
        };
      };

      # Syntax highlighting
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
      };

      # Keep current context header line visible
      treesitter-context = {
        # Some .nix files use too many lines for inputs declaration
        enable = false;
        settings = {
          # separator = ""; # Attempt to remove the underline separator
          line_numbers = false;
        };
      };

      # Quickly comment code lines or blocks
      comment = {
        enable = true;
        settings = {
          # NORMAL and VISUAL mode
          opleader = {
            block = "<C-b>";
            line = "<C-c>";
          };
          # Line in NORMAL mode
          toggler = {
            block = "<C-b>";
            line = "<C-c>";
          };
          extra = {
            # TODO: Set easier trigram
            above = "gcO";
            below = "gco";
            eol = "gcA";
          };
          # Enable extra mappings (gco, gcO, gcA).
          mappings.extra = true;
        };
      };

      # Reverse any action and alternative action
      undotree.enable = true;

      # Highlight hovered word occurences
      illuminate.enable = true;

      # Debugging interface
      dap.enable = true;

      # Display colors next to RGB hex codes
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          names = false;
          mode = "virtualtext";
          virtualtext = "⬤ ";
        };
      };

      # Center text on screen
      zen-mode.enable = true;

      # Replace `.netrw`
      oil.enable = true;

      # Help remembering keybindings
      which-key.enable = true;

      # Indentation guidelines
      indent-blankline = {
        enable = false;
        settings = { scope.enabled = false; };
      };

      # Quickly jump between registered buffers
      harpoon.enable = true;

      # Lazy load plugins for faster startup
      # TODO: Test if more configuration is needed for nixvim
      lazy.enable = true;

      # Syntax highlighting for Nix
      # Filetype detection for .nix files
      # Automatic indentation
      # NixEdit command: navigate nixpkgs by attribute name
      nix.enable = true;

      # Styled status line at the bottom
      lualine.enable = true;

      # Manipulate brackets and quotations
      surround.enable = true;

      noice = {
        enable = true;
      };

      notify = {
        enable = true;
        maxWidth = 50;

        # Reduce network usage for remote sessions
        stages = "static";
        fps = null;
      };

      # Show breadcrumbs on the first line
      navic = {
        enable = true;
        highlight = true;
      };

      navbuddy.enable = true;

      trouble.enable = true;
    };

    keymaps = [
      # LSP Actions
      { mode = "n"; key = "gd"; action = "vim.lsp.buf.definition()"; }
      { mode = "n"; key = "<S-k>"; action = "vim.lsp.buf.hover()"; }
      { mode = "n"; key = "<leader>vca"; action = "vim.lsp.buf.code_action()"; }
      { mode = "n"; key = "<leader>vrr"; action = "vim.lsp.buf.references()"; }
      { mode = "n"; key = "<leader>vrn"; action = "vim.lsp.buf.rename()"; }
      { mode = "i"; key = "<C-h>"; action = "vim.lsp.buf.signature_help()"; }

      # Save / Quit
      { mode = "n"; key = "<leader>w"; options.silent = true; action = ":w<CR>"; }
      { mode = "n"; key = "<leader>q"; options.silent = true; action = ":q<CR>"; }
      { mode = "n"; key = "<leader>e"; options.silent = true; action = ":Oil<CR>"; }

      # Move highlighted line(s) up and down
      { mode = "v"; key = "J"; options.silent = true; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; options.silent = true; action = ":m '<-2<CR>gv=gv"; }

      # Keep cursor in place after `J`
      # TODO: This removes leading `/*` from current line
      { mode = "n"; key = "J"; action = "mzJ`z"; }

      # Keep cursor in the middle during half page jumps
      { mode = "n"; key = "<C-d>"; options.silent = true; action = "<C-d>zz"; }
      { mode = "n"; key = "<C-u>"; options.silent = true; action = "<C-u>zz"; }

      # Keep search matches centered
      { mode = "n"; key = "n"; options.silent = true; action = "nzzzv"; }
      { mode = "n"; key = "N"; options.silent = true; action = "Nzzzv"; }

      # Preserve copy buffer on override
      { mode = "x"; key = "<leader>p"; options.silent = true; action = ''"_dP''; }

      # Copy to clipboard
      { mode = "n"; key = "<leader>y"; options.silent = true; action = ''"+y''; }
      { mode = "v"; key = "<leader>y"; options.silent = true; action = ''"+y''; }
      { mode = "n"; key = "<leader>Y"; options.silent = true; action = ''"+Y''; }

      # Search and replace word under cursor in current buffer
      {
        mode = "n";
        key = "<leader>s";
        options = {
          silent = true;
          desc = "Replace all occurences in buffer";
        };
        action = "[[:%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>]]";
      }

      # quick fix navigation
      #       vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
      #       vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
      #       vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
      #       vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

    ];
  };

}
