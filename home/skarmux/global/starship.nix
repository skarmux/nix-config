{
  programs.starship = {
    enable = true;

    settings = {

      format = ''
        $directory
        ( $nix_shell)( $rust)( $git_branch$git_commit$git_state$git_metrics( $git_status)
        )$jobs$character
      '';

      add_newline = true;

      fill = {
        symbol = " ";
        disabled = false;
      };

      # Core
      username = {
        show_always = true;
        format = "[$user](bold fg:blue)";
      };

      hostname = {
        format = "[$hostname](bold fg:blue)";
        ssh_only = false;
      };

      shlvl = {
        format = "[$shlvl]($style) ";
        style = "bold cyan";
        symbol = "";
        threshold = 2;
        repeat = true;
        disabled = false;
      };

      cmd_duration = {
        min_time = 10000; # 10 seconds
        format = ''
          [ $duration
          ]($style)'';
        style = "bold yellow";
      };

      directory = {
        format = "[$path](bold blue)";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = true;
        home_symbol = "󰋜 ";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
        };
      };

      nix_shell = {
        format = "[$symbol]($style)";
        symbol = " ";
      };

      battery = {
        display = [
          {
            threshold = 15;
            style = "bold red";
          }
          {
            threshold = 60;
            style = "bold yellow";
          }
          {
            threshold = 100;
            style = "bold green";
          }
        ];
      };

      time = {
        format = "[ $time ](bold fg:black bg:blue)";
        time_format = "%e. %b (%a) %R";
        disabled = false;
      };

      git_branch = {
        symbol = "";
        format = "[$symbol $branch(:$remote_branch)]($style)";
      };

      rust = {
        format = "[$symbol ($version)]($style)";
        version_format = "\${major}.\${minor}";
        symbol = ""; # 
      };

    };

  };
}

