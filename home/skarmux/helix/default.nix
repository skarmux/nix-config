{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption mkMerge types;
  cfg = config.programs.helix;
in
{
  imports = [
    ./languages/html.nix
    ./languages/rust.nix
    ./languages/toml.nix
    ./languages/typst.nix
    ./languages/php.nix
    ./languages/javascript.nix
  ];
  
  options.programs.helix = {
    tree-file-picker = mkOption {
      type = types.enum [ "zellij" "tmux" "none" ];
      default = "none";
      description = ''
        Use a file tree from within helix and open additional files.
        Only "zellij" supports a floating window.
      '';
    };
    llm = mkEnableOption "Additional keymaps for prompting `pkgs.llm`";
  };

  config = mkMerge [
    {
     programs.helix = {
        settings = {
          editor = import ./editor.nix;
          keys.normal = {
            # Allow `esc` to close multi-cursor mode
            esc = [ "collapse_selection" "keep_primary_selection" ];
          };
        };
      };
    }

    (mkIf (cfg.tree-file-picker == "tmux") {
      # File tree picker in Helix with tmux
      # https://yazi-rs.github.io/docs/tips/#helix-with-tmux
      
      programs.yazi.enable = true;
      programs.tmux.enable = true;
          
      home.file.".config/helix/yazi-picker.sh" = {
        text = ''
          #!/usr/bin/env bash
          paths=$(yazi --chooser-file=/dev/stdout)
          if [[ -n "$paths" ]]; then
            tmux last-window
            tmux send-keys Escape
            tmux send-keys ":$1 $paths"
            tmux send-keys Enter
          else
            tmux kill-window -t fx
          fi
        '';
        executable = true;
      };

      programs.helix.settings.keys.normal = {
        C-y = ":sh tmux new-window -n fx '~/.config/helix/yazi-picker.sh open'";
      };
    })

    (mkIf (cfg.tree-file-picker == "zellij") {
      # File tree picker in Helix with zellij
      # https://yazi-rs.github.io/docs/tips/#helix-with-zellij
      
      programs.yazi.enable = true;
      programs.zellij.enable = true;
      
      home.file.".config/helix/yazi-picker.sh" = {
        text = ''
          #!/usr/bin/env bash
          paths=$(yazi "$2" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)
          if [[ -n "$paths" ]]; then
            zellij action toggle-floating-panes
            zellij action write 27 # send <Escape> key
            zellij action write-chars ":$1 $paths"
            zellij action write 13 # send <Enter> key
          else
            zellij action toggle-floating-panes
          fi
        '';
        executable = true;
      };

      programs.helix.settings.keys.normal = {
        C-y = ":sh zellij run -n Yazi -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- bash ~/.config/helix/yazi-picker.sh open %{buffer_name}";
      };
    })

    (mkIf cfg.llm {

      home.packages = [ pkgs.lsp-ai ];
      
      # Sops secrets need to be loaded from files at runtime
      programs.bash.initExtra = ''
        export OPENAI_API_TOKEN=$(cat ${config.sops.secrets."openai/simonw-llm".path})
      '';

      programs.helix.languages = {

        language-server.lsp-ai = {
          command = "lsp-ai";
          # args = [ "--stdio" ];
          # timeout
          # environment = { };
          # required-root-patterns
          config = {
          
            # NOTE: Not configurable yet. Waiting for updates.
            #       Allows for the use of vector databases and such.
            # https://github.com/SilasMarvin/lsp-ai/wiki/Configuration#memory
            memory = { file_store = {}; };

            # https://github.com/SilasMarvin/lsp-ai/wiki/Configuration#models
            models = {
              model1 = {
                type = "ollama";
                model = "deepseek-coder";
              };
              model2 = {
                type = "open_ai";
                chat_endpoint = "https://api.openai.com/v1/chat/completions";
                model = "gpt-4o";
                auth_token_env_var_name = "OPENAI_API_TOKEN";
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
                  system = "You are an AI coding assistant. Your task is to complete code snippets. The user's cursor position is marked by \"<CURSOR>\". Follow these steps:\n\n1. Analyze the code context and the cursor position.\n2. Provide your chain of thought reasoning, wrapped in <reasoning> tags. Include thoughts about the cursor position, what needs to be completed, and any necessary formatting.\n3. Determine the appropriate code to complete the current thought, including finishing partial words or lines.\n4. Replace \"<CURSOR>\" with the necessary code, ensuring proper formatting and line breaks.\n5. Wrap your code solution in <answer> tags.\n\nYour response should always include both the reasoning and the answer. Pay special attention to completing partial words or lines before adding new lines of code.\n\n<examples>\n<example>\nUser input:\n--main.py--\n# A function that reads in user inpu<CURSOR>\n\nResponse:\n<reasoning>\n1. The cursor is positioned after \"inpu\" in a comment describing a function that reads user input.\n2. We need to complete the word \"input\" in the comment first.\n3. After completing the comment, we should add a new line before defining the function.\n4. The function should use Python's built-in `input()` function to read user input.\n5. We'll name the function descriptively and include a return statement.\n</reasoning>\n\n<answer>t\ndef read_user_input():\n    user_input = input(\"Enter your input: \")\n    return user_input\n</answer>\n</example>\n\n<example>\nUser input:\n--main.py--\ndef fibonacci(n):\n    if n <= 1:\n        return n\n    else:\n        re<CURSOR>\n\n\nResponse:\n<reasoning>\n1. The cursor is positioned after \"re\" in the 'else' clause of a recursive Fibonacci function.\n2. We need to complete the return statement for the recursive case.\n3. The \"re\" already present likely stands for \"return\", so we'll continue from there.\n4. The Fibonacci sequence is the sum of the two preceding numbers.\n5. We should return the sum of fibonacci(n-1) and fibonacci(n-2).\n</reasoning>\n\n<answer>turn fibonacci(n-1) + fibonacci(n-2)</answer>\n</example>\n</examples>";
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
              {
                action_display_name = "Refactor";
                model = "model2";
                parameters = {
                  max_content = 4096;
                  max_tokens = 4096;
                  system = "You are an AI coding assistant specializing in code refactoring. Your task is to analyze the given code snippet and provide a refactored version. Follow these steps:\n\n1. Analyze the code context and structure.\n2. Identify areas for improvement, such as code efficiency, readability, or adherence to best practices.\n3. Provide your chain of thought reasoning, wrapped in <reasoning> tags. Include your analysis of the current code and explain your refactoring decisions.\n4. Rewrite the entire code snippet with your refactoring applied.\n5. Wrap your refactored code solution in <answer> tags.\n\nYour response should always include both the reasoning and the refactored code.\n\n<examples>\n<example>\nUser input:\ndef calculate_total(items):\n    total = 0\n    for item in items:\n        total = total + item['price'] * item['quantity']\n    return total\n\n\nResponse:\n<reasoning>\n1. The function calculates the total cost of items based on price and quantity.\n2. We can improve readability and efficiency by:\n   a. Using a more descriptive variable name for the total.\n   b. Utilizing the sum() function with a generator expression.\n   c. Using augmented assignment (+=) if we keep the for loop.\n3. We'll implement the sum() function approach for conciseness.\n4. We'll add a type hint for better code documentation.\n</reasoning>\n<answer>\nfrom typing import List, Dict\n\ndef calculate_total(items: List[Dict[str, float]]) -> float:\n    return sum(item['price'] * item['quantity'] for item in items)\n</answer>\n</example>\n\n<example>\nUser input:\ndef is_prime(n):\n    if n < 2:\n        return False\n    for i in range(2, n):\n        if n % i == 0:\n            return False\n    return True\n\n\nResponse:\n<reasoning>\n1. This function checks if a number is prime, but it's not efficient for large numbers.\n2. We can improve it by:\n   a. Adding an early return for 2, the only even prime number.\n   b. Checking only odd numbers up to the square root of n.\n   c. Using a more efficient range (start at 3, step by 2).\n3. We'll also add a type hint for better documentation.\n4. The refactored version will be more efficient for larger numbers.\n</reasoning>\n<answer>\nimport math\n\ndef is_prime(n: int) -> bool:\n    if n < 2:\n        return False\n    if n == 2:\n        return True\n    if n % 2 == 0:\n        return False\n    \n    for i in range(3, int(math.sqrt(n)) + 1, 2):\n        if n % i == 0:\n            return False\n    return True\n</answer>\n</example>\n</examples>";
                  messages = [
                    {
                      role = "user";
                      content = "{SELECTED_TEXT}";
                    }
                  ];
                };
                post_process = {
                  extractor = "(?s)<answer>(.*?)</answer>";
                };
              }
            ];

            completion = {
              model = "model1";
              parameters = {};
            };

          };
        };
      };
    })
    
  ];
}

