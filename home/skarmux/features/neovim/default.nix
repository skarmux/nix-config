{ config, pkgs, ... }: {
  imports = [
    ./completion
    ./ollama
    ./rust
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    # TODO: Not part of catppuccin-nix
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = config.catppuccin.flavour;
    };

    filetype = {
      # Neovim does associate typst files with sql for some reason. Force typst.
      extension.typ = "typst";
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
      colorcolumn = "80";
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
        keymapsSilent = true;
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
        enable = true;
        settings = {
          separator = "";
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

      # Obsidian integration
      #obsidian = {
      #  enable = true;
      #  settings = {
      #    workspaces = [{
      #      name = "personal";
      #      path = "${config.xdg.userDirs.documents}/obsidian/personal";
      #    }];
      #  };
      #};

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

      # Neovim native lsp support
      lsp = {
        enable = true;
        servers = {
          gdscript.enable = true;
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
          typst-lsp = {
            enable = true;
            filetypes = [ "typst" ];
          };
        };
      };
      lsp-format.enable = true;

      # Render diagnostics results inline
      lsp-lines.enable = true;

      # Syntax highlighting for Nix
      # Filetype detection for .nix files
      # Automatic indentation
      # NixEdit command: navigate nixpkgs by attribute name
      nix.enable = true;

      # Per line git status symbols in extra column
      gitsigns.enable = true;

      # Styled status line at the bottom
      lualine.enable = true;

      # LSP process status messages
      fidget.enable = true;

      # Git command integration
      fugitive.enable = true;

      # Manipulate brackets and quotations
      surround.enable = true;

      # multicursors.enable = true;

      # pretty-fold-nvim
      # formatter-nvim
      # vim-abolish
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        options.silent = true;
        action = ":w<CR>";
      }
      {
        mode = "n";
        key = "<leader>q";
        options.silent = true;
        action = ":wq<CR>";
      }
      {
        mode = "n";
        key = "<leader>e";
        options.silent = true;
        action = ":Oil<CR>";
      }

      # Move highlighted line(s) up and down
      {
        mode = "n";
        key = "J";
        options.silent = true;
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "n";
        key = "K";
        options.silent = true;
        action = ":m '<-2<CR>gv=gv";
      }

      # Keep cursor in place after `J`
      # TODO: This removes leading `/*` from current line
      {
        mode = "n";
        key = "J";
        options.silent = true;
        action = "mzJ`z";
      }

      # Keep cursor in the middle during half page jumps
      {
        mode = "n";
        key = "<C-d>";
        options.silent = true;
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        options.silent = true;
        action = "<C-u>zz";
      }

      # Keep search matches centered
      {
        mode = "n";
        key = "n";
        options.silent = true;
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        options.silent = true;
        action = "Nzzzv";
      }

      # Preserve copy buffer on override
      {
        mode = "x";
        key = "<leader>p";
        options.silent = true;
        action = ''"_dP'';
      }

      # Copy to clipboard
      {
        mode = "n";
        key = "<leader>y";
        options.silent = true;
        action = ''"+y'';
      }
      {
        mode = "v";
        key = "<leader>y";
        options.silent = true;
        action = ''"+y'';
      }
      {
        mode = "n";
        key = "<leader>Y";
        options.silent = true;
        action = ''"+Y'';
      }

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

  # TODO: Only for desktop environments
  # xdg.desktopEntries.nvim = {
  #   name = "Neovim";
  #   genericName = "Text Editor";
  #   exec = "${config.home.sessionVariables.TERMINAL} -e nvim %F";
  #   icon = "nvim";
  #   mimeType = [
  #     "text/english"
  #     "text/plain"
  #     "text/x-makefile"
  #     "text/x-c++hdr"
  #     "text/x-c++src"
  #     "text/x-chdr"
  #     "text/x-csrc"
  #     "text/x-java"
  #     "text/x-moc"
  #     "text/x-pascal"
  #     "text/x-tcl"
  #     "text/x-tex"
  #     "application/x-shellscript"
  #     "text/x-c"
  #     "text/x-c++"
  #   ];
  #   # terminal = true;
  #   type = "Application";
  # };

  # xdg.mimeApps.defaultApplications = {
  #   "text/plain" = [ "nvim.desktop" ];
  #   "text/markdown" = [ "nvim.desktop" ];
  # };
}
