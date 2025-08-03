{
  scrolloff = 8;
  mouse = true;
  middle-click-paste = true;
  scroll-lines = 3;
  shell = [ "sh" "-c" ];
  line-number = "relative";
  cursorline = true;
  cursorcolumn = false;
  continue-comments = false;
  auto-completion = true;
  path-completion = true;
  auto-format = true;
  idle-timeout = 0;
  preview-completion-insert = true;
  completion-trigger-len = 1;
  completion-replace = false;
  auto-info = true;
  true-color = true;
  undercurl = false;
  rulers = [ ];
  bufferline = "never"; # always | never | multiple
  color-modes = true;
  text-width = 80;
  default-line-ending = "lf";
  insert-final-newline = false;

  clipboard-provider = "tmux";

  statusline = {
    left = [ "mode" "diagnostics" ];
    center =
      [ "file-name" "file-modification-indicator" "read-only-indicator" ];
    right = [
      "spinner" # indicating lsp activity
      "register"
      "file-type"
      "file-encoding"
      "position"
    ];
    separator = "|";
    mode.normal = "NORMAL";
    mode.insert = "INSERT";
    mode.select = "VISUAL";
  };

  lsp = {
    enable = true;
    display-messages = false;
    auto-signature-help = true;
    display-inlay-hints = true;
    display-signature-help-docs = true;
    snippets = true;
    goto-reference-include-declaration = true;
  };

  cursor-shape = {
    insert = "block";
    normal = "block";
    select = "block";
  };

  file-picker = {
    hidden = false;
    follow-symlinks = true;
    deduplicate-links = true;
    parents = true;
    ignore = true;
    git-ignore = true;
    git-global = false;
    git-exclude = false;
  };

  auto-pairs = true;

  auto-save = {
    focus-lost = false;
    after-delay.enable = false;
    after-delay.timeout = 3000;
  };

  search = {
    smart-case = true;
    wrap-around = true;
  };

  whitespace = {
    render = {
      tab = "all";
      nbsp = "all";
    };
    characters.tab = "→";
    characters.tabpad = "·";
    characters.nbsp = "⍽";
  };

  indent-guides = {
    render = false;
    character = "│"; # Some characters that work well: "▏", "┆", "┊", "⸽"
    skip-levels = 0;
  };

  gutters = {
    layout = [ "diff" "diagnostics" ];
    line-numbers.min-width = 2;
  };

  soft-wrap.enable = false;

  smart-tab = {
    enable = true;
    supersede-menu = false;
  };

  inline-diagnostics = {
    # error, warning, info, hint, disable
    cursor-line = "hint";
    other-lines = "error";
    max-diagnostics = 10;
  };
}
