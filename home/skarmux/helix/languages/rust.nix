{
  programs.helix.languages = {
    language-server.rust-analyzer = {
      command = "rust-analyzer";
      args = [ "--stdio" ]; # TODO: Figure out why --stdio is there
      config = {
        # Use `clippy` for diagnostics
        # TODO Is clippy guaranteed to be insalled via toolchain?
        check = { command = "clippy"; };
      };
      # timeout
      # environment
      # required-root-patterns
    };

    language = [
      {
        name = "rust";
        file-types = [ "rs" ];
        indent = {
          tab-width = 4;
          unit = " ";
        };
        formatter = {
          command = "rustfmt";
        };
        text-width = 80;
        auto-format = true;
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
          "`" = "`";
          "<" = ">";
          "=" = ";";
        };
        language-servers = [ "rust-analyzer" ];
      }
    ];
  };
}
