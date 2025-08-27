{
  programs.helix.languages = {
    language-server.qmlls = {
      command = "qmlls";
      args = [ "-E" ];
    };

    # language = [{
    #   name = "qml";
    #   file-types = [ "html" ];
    #   indent = {
    #     tab-width = 4;
    #     unit = " ";
    #   };
    #   language-servers = [
    #     "vscode-html-language-server"
    #     "tailwindcss-ls"
    #   ];
    #   text-width = 140;
    #   soft-wrap = {
    #     enable = true;
    #     wrap-at-text-width = false;
    #   };
    # }];
  
  };
}
