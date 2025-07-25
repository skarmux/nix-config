{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.programs.helix.lsp-ai;
  exportToken = ''
    export OPENAI_API_KEY=$(cat ${cfg.openai.authTokenFile})
  '';
in
{
  options.programs.helix.lsp-ai = {
    enable = mkEnableOption ''
      LSP-AI is an open-source language server that serves as a backend for
      AI-powered functionality, designed to assist and empower software
      engineers, not replace them.
    '';
    openai = {
      enable = mkEnableOption "Use OpenAI API endpoints for GPT integration.";
      authTokenFile = mkOption {
        type = types.str;
        description = "File with API token from your openai account.";
      };
    };
  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.lsp-ai ];

    # Sops secrets need to be loaded from files at runtime
    programs.bash.initExtra = exportToken;
    programs.zsh.initExtra = exportToken;
    programs.fish.loginShellInit = exportToken;
    programs.nushell.extraLogin = exportToken;

    programs.helix.languages.language-server.lsp-ai = {

      command = "lsp-ai";

      # args = [ "--stdio" ];
      # timeout
      # environment = { };
      # required-root-patterns

      config = {

        # NOTE: Not configurable yet. Waiting for updates.
        #       Allows for the use of vector databases and such.
        # https://github.com/SilasMarvin/lsp-ai/wiki/Configuration#memory
        memory = { file_store = { }; };

        # https://github.com/SilasMarvin/lsp-ai/wiki/Configuration#models
        models = {
          model1 = {
            type = "ollama";
            model = "deepseek-coder";
          };
          model2 = {
            chat_endpoint = "https://api.openai.com/v1/chat/completions";
            completions_endpoint = "https://api.openai.com/v1/chat/completions";
            model = "gpt-4o";
            auth_token_env_var_name = "OPENAI_API_KEY";
            type = "open_ai";
          };
        };

        chat = [
          {
            trigger = "!C";
            action_display_name = "Chat";
            model = "model2";
            parameters = {
              max_context = 4096;
              max_tokens = 1024;
              messages = [
                {
                  role = "system";
                  content = "You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately";
                }
              ];
            };
          }
          # NOTE: that to actually have context in the "Chat with context"
          # action you need to use a Memory Backend that provides context
          # (not the FileStore backend).
          # 
          # {
          #   trigger = "!CC";
          #   action_display_name = "Chat with context";
          #   model = "model1";
          #   parameters = {
          #     max_context = 4096;
          #     max_tokens = 1024;
          #     messages = [
          #       {
          #         role = "system";
          #         content = /* text */ ''
          #           You are a code assistant chatbot. The user will ask you
          #           for assistance coding and you will do you best to
          #           answer succinctly and accurately given the code context:
          #           \n\n{CONTEXT}
          #         '';
          #       }
          #     ];
          #   };
          # }
        ];

        actions = [
          {
            action_display_name = "Complete";
            model = "model2";
            parameters = {
              max_content = 4096;
              max_tokens = 4096;
              system = builtins.readFile ./actions/complete.md;
              messages = [
                {
                  role = "user";
                  content = "{CODE}";
                }
              ];
            };
            post_process = {
              extractor = "(?s)<answer>(.*?)</answer>";
            };
          }
          # {
          #   action_display_name = "Refactor";
          #   model = "model2";
          #   parameters = {
          #     max_content = 4096;
          #     max_tokens = 4096;
          #     system = builtins.readFile ./actions/refactor.md;
          #     messages = [
          #       {
          #         role = "user";
          #         content = "{SELECTED_TEXT}";
          #       }
          #     ];
          #   };
          #   post_process = {
          #     extractor = "(?s)<answer>(.*?)</answer>";
          #   };
          # }
        ];

        completion = {
          model = "model2";
          parameters = { };
        };
      };
    };
  };
}
