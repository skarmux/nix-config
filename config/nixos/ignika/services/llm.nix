{ pkgs, unstable, ... }:
# Uses Ollama for local models and lsp-ai for code editor integration as well as
# opencode for project based agent automation.
{
  services.ollama = {
    enable = true;
    loadModels = [
      "deepseek-coder:33b"
    ];
    acceleration = "cuda";
    # port = 11434;
    # openFirewall = false;
    # home = "/var/lib/ollama";
  }; 

  environment.systemPackages = with pkgs; [
    llm
    lsp-ai
  ] ++ [ unstable.opencode ];

  home-manager.users.skarmux = {

    # TODO: Supposed to be inside a project root
    # home.file."Templates/opencode.json".text = ''
    #   {
    #     "$schema": "https://opencode.ai/config.json",
    #     "theme": "tokyonight",
    #     "provider": {
    #       "ollama": {
    #         "npm": "@ai-sdk/openai-compatible",
    #         "name": "Ollama (local)",
    #         "options": {
    #           "baseURL": "http://localhost:11434/v1"
    #         },
    #         "models": {
    #           "deepseek-coder:33b": {
    #             "name": "Deepseek Coder"
    #           }
    #         }
    #       }
    #     }
    #   }
    # '';
    
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
        };

        chat = [
          # {
          #   trigger = "!C";
          #   action_display_name = "Chat";
          #   model = "model2";
          #   parameters = {
          #     max_context = 4096;
          #     max_tokens = 1024;
          #     messages = [
          #       {
          #         role = "system";
          #         content = "You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately";
          #       }
          #     ];
          #   };
          # }
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
          # {
          #   action_display_name = "Complete";
          #   model = "model2";
          #   parameters = {
          #     max_content = 4096;
          #     max_tokens = 4096;
          #     system = builtins.readFile ./actions/complete.md;
          #     messages = [
          #       {
          #         role = "user";
          #         content = "{CODE}";
          #       }
          #     ];
          #   };
          #   post_process = {
          #     extractor = "(?s)<answer>(.*?)</answer>";
          #   };
          # }
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
          model = "model1";
          parameters = { };
        };
      };
    };
  };
}