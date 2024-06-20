{
  programs.nixvim = {
    filetype = {
      # Neovim does associate typst files with sql for some reason. Force typst.
      extension.typ = "typst";
    };
    plugins.lsp.servers = {
      typst-lsp = {
        enable = true;
        filetypes = ["typst"];
      };
    };
  };
}
