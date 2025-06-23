{ lib, config, ... }:
{
  programs.wofi = {
    settings = {
      insensitive = true;
      # matching = "fuzzy";
      # show = "drun";
      allow_images = true;
      image_size = 48;
      prompt = "";
      no_actions = true;
      single_click = true;
      columns = 1;
      # cache_file = "/dev/null";
      # normal_window = true;
    };
    # style = /* css */ ''
    #   window {
    #     margin: 0px;
    #     background-color: #000000;
    #     opacity: 0.1;
    #     font-family: "Fira Code Mono";
    #     font-size: 12pt;
    #   }

    #   #outer-box {
    #     margin: 5px;
    #     border: none;
    #   }

    #   #input {
    #     margin: 5px;
    #     border: none;
    #     background-color: none;
    #     color: #ffffff;
    #   }

    #   #input:focus {
    #     border-color: #ffffff;
    #   }

    #   #scroll {
    #     margin: 0px;
    #     border: none;
    #   }

    #   #inner-box {
    #     margin: 5px;
    #     border: none;
    #   }

    #   #entry.activatable #text {
    #   }

    #   #entry > * {
    #   }

    #   #entry:selected {
    #   }

    #   #entry:selected #text {
    #     font-weight: bold;
    #   }

    #   #entry:nth-child(odd) {
    #   }

    #   #entry:nth-child(even) {
    #   }

    #   #entry:selected {
    #   }
      
    #   #text {
    #     margin: 5px;
    #     border: none;
    #   } 
    # '';
  };
}
