{ pkgs, config, ... }: {
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.ChatGPT-nvim ];

    extraConfigLua = # lua
      ''
        require("chatgpt").setup({
          api_key_cmd = "cat ${config.sops.secrets.openai-token.path}",
        })
      '';
  };

  sops.secrets.openai-token.path = "${config.home.homeDirectory}/openai-token";
}
