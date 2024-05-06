{ colorscheme }: {
  # https://docs.helix-editor.com/themes.html
  "${colorscheme.slug}" = {
    palette = builtins.mapAttrs (name: value: "#${value}") colorscheme.palette;

    # Syntax highlighting

    "attribute" = "base09";
    "type" = "base0A";
    "constructor" = "base0D";
    "constant" = "base09";
    "constant.character.escape" = "base0C";
    "constant.numeric" = "base09";
    "string" = "base0B";
    "comment" = {
      fg = "base09";
      modifiers = [ "italic" ];
    };
    "variable" = "base08";
    "variable.other.member" = "base08";
    "label" = "base0E";
    "keyword" = "base0E";
    "operator" = "base05";
    "function" = "base0D";
    "namespace" = "base0E";
    "special" = "base0D";
    "markup.bold" = {
      fg = "base0A";
      modifiers = [ "bold" ];
    };
    "markup.heading" = "base0D";
    "markup.italic" = {
      fg = "base0E";
      modifiers = [ "italic" ];
    };
    "markup.link.text" = "base08";
    "markup.link.url" = {
      fg = "base09";
      modifiers = [ "underlined" ];
    };
    "markup.list" = "base08";
    "markup.quote" = "base0C";
    "markup.raw" = "base0B";
    "markup.strikethrough" = { modifiers = [ "crossed_out" ]; };
    "diff.delta" = "base09";
    "diff.minus" = "base08";
    "diff.plus" = "base0B";

    # Interface

    "ui.background" = { bg = "base00"; };
    "ui.bufferline" = {
      fg = "base04";
      bg = "base00";
    };
    "ui.bufferline.active" = {
      fg = "base00";
      bg = "base00";
      modifiers = [ "bold" ];
    };

    "ui.cursor" = {
      fg = "base01";
      bg = "base05";
    };
    # "ui.cursor.insert" = { bg = "base0B"; modifiers = [ "reversed" ]; };
    # "ui.cursor.match" = { bg = "base09"; modifiers = [ "reversed" ]; };
    # "ui.cursor.select" = { bg = "base0A"; modifiers = [ "reversed" ]; };
    "ui.cursorline.primary" = {
      fg = "base05";
      bg = "base00";
    };

    "ui.gutter" = { bg = "base00"; };
    "ui.help" = {
      fg = "base05";
      bg = "base00";
    };
    "ui.linenr" = {
      fg = "base05";
      bg = "base00";
    };
    "ui.linenr.selected" = {
      fg = "base0B";
      bg = "base00";
      modifiers = [ "bold" ];
    };

    "ui.menu" = {
      fg = "base05";
      bg = "base00";
    };
    "ui.menu.scroll" = {
      fg = "base03";
      bg = "base00";
    };
    "ui.menu.selected" = {
      fg = "base01";
      bg = "base00";
    };

    "ui.popup" = { bg = "base00"; };

    "ui.selection" = {
      fg = "base01";
      bg = "base0A";
    };
    "ui.selection.primary" = {
      fg = "base01";
      bg = "base0A";
    };

    "ui.statusline" = {
      fg = "base0E";
      bg = "base00";
    };
    "ui.statusline.inactive" = {
      fg = "base04";
      bg = "base00";
    };
    "ui.statusline.insert" = {
      fg = "base0B";
      bg = "base00";
    };
    "ui.statusline.normal" = {
      fg = "base05";
      bg = "base00";
    };
    "ui.statusline.select" = {
      fg = "base0A";
      bg = "base00";
    };

    "ui.text" = "base05";
    "ui.text.focus" = "base05";

    "ui.virtual.indent-guide" = { fg = "base0D"; };
    "ui.virtual.ruler" = { bg = "base01"; };
    "ui.virtual.whitespace" = { fg = "base01"; };
    "ui.virtual.inlay-hint" = { fg = "base07"; };

    "ui.window" = { bg = "base01"; };

    "warning" = "base09";
    "error" = "base08";
    "info" = "base0D";
    "hint" = "base03";

    "diagnostic" = { modifiers = [ "underlined" ]; };
    "diagnostic.hint" = { underline = { style = "curl"; }; };
    "diagnostic.info" = { underline = { style = "curl"; }; };
    "diagnostic.warning" = { underline = { style = "curl"; }; };
    "diagnostic.error" = { underline = { style = "curl"; }; };

  };
}
