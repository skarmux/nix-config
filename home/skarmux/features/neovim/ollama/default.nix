{
  programs.nixvim.plugins.ollama = {
    enable = true;
    model = "llama3";
    url = "http://127.0.0.1:11434";

    prompts."Correct_Grammar" = {
      prompt = ''
        Fix any grammar mistakes and wording so that it is both easier to read and understand.
        ```$ftype
        $sel```
      '';
      action = "replace";
    };
  };
}
