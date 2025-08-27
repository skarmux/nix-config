{ pkgs, ... }:
{
  programs.helix.languages = {

    language-server.tinymist = {
      command = "tinymist";
    };

    language = [
      {
        name = "typst";
        file-types = [ "typ" ];
        scope = "source.typst";
        roots = [ ];
        comment-token = "//";
        indent = {
          tab-width = 2;
          unit = " ";
        };
        formatter = {
          command = "typstfmt";
          args = [ "--output" "-" ];
        };
        auto-format = true;
        language-servers = [
          "typst-lsp"
        ];
      }
    ];

    grammar = [
      {
        name = "typst";
        source.path = "${pkgs.tree-sitter-grammars.tree-sitter-typst}";
      }
    ];
  };
}
