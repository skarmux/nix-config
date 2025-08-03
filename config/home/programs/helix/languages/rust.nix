{
  programs.helix.languages = {
    language-server.rust-analyzer = {
      command = "rust-analyzer";
      # args = [ ];
      config = {
        # Use `clippy` for diagnostics
        # TODO Is clippy guaranteed to be insalled via toolchain?
        check = { command = "clippy"; };
        cargo = {
          features = [ "all" ];
          allFeatures = true;
        };
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
        text-width = 100;
        auto-format = true;
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
          "`" = "`";
          "<" = ">";
          # "=" = ";";
        };
        language-servers = [ "rust-analyzer" ];
        soft-wrap = {
          enable = true;
          wrap-at-text-width = false;
        };
      }
    ];
  };
}
