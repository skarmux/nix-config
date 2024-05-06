{
  programs.nixvim.plugins = {

    luasnip.enable = true;

    # A super powerful autopair plugin for Neovim that supports multiple characters.
    # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
    nvim-autopairs.enable = true;

    cmp-nvim-lsp.enable = true;
    cmp-vim-lsp.enable = true;
    cmp_luasnip.enable = true;

    cmp = {
      enable = true;

      settings = {

        snippet.expand = "luasnip";

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          { name = "nvim_lua"; }
          { name = "path"; }
        ];

        window = {
          completion = {
            winhighlight =
              "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:PmenuSel,Search:PmenuSel";
            scrollbar = false;
            sidePadding = 0;
            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
          };
          documentation = {
            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
            winhighlight =
              "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:PmenuSel,Search:PmenuSel";
          };
        };

        mapping = {
          "<Down>" = # lua
          ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end
          '';
          "<Up>" = # lua
          ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end
          '';
          "<PageUp>" = "cmp.mapping.scroll_docs(-4)";
          "<PageDown>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = # lua
          ''
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = false
            })
          '';
        }; # mapping

        formatting = {
          fields = [ "abbr" "kind" "menu" ];
          format = # lua
            ''
              function(_, item)
                local icons = {
                  Namespace = "󰌗",
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰆧",
                  Constructor = "",
                  Field = "󰜢",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈚",
                  Reference = "󰈇",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "󰙅",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰊄",
                  Table = "",
                  Object = "󰅩",
                  Tag = "",
                  Array = "[]",
                  Boolean = "",
                  Number = "",
                  Null = "󰟢",
                  String = "󰉿",
                  Calendar = "",
                  Watch = "󰥔",
                  Package = "",
                  Copilot = "",
                  Codeium = "",
                  TabNine = "",
                }

                local icon = icons[item.kind] or ""
                item.kind = string.format("%s %s", icon, item.kind or "")
                return item
              end
            '';
        }; # formatting
      }; # settings
    }; # cmp
  };
}
