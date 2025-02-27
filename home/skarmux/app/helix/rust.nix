{
  language-server.rust-analyzer = {
    command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };

  language = [
    {
      name = "rust";
      file-types = [ "rs" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      formatter = { command = "${pkgs.rustfmt}/bin/rustfmt"; };
      text-width = 80;
      auto-format = true;
    }
    {
      name = "toml";
      file-types = [ "toml" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      text-width = 80;
      auto-format = true;
    }
  ];
}
