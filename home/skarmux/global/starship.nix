{
  programs.starship = {
    enable = true;

    settings = {

      format = ''
        (($status )$cmd_duration
        )$directory( $git_status)( $git_metrics)$fill($git_branch)( $c)( $kotlin)( $java)( $nodejs)( $go)( $zig)( $php)( $python)( $rust)( $nix_shell)
        $jobs$character
      '';

      add_newline = false;

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

      cmd_duration = {
        min_time = 10000; # 10 seconds
        format = ''
          [ $duration
          ]($style)'';
        style = "bold yellow";
      };

      directory = {
        format = "[$path](bold blue)";
        truncation_length = 0;
        truncation_symbol = "󰉋 ";
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

      git_branch = {
        symbol = "";
        format = "[$symbol $branch(:$remote_branch)]($style)";
        style = "bold blue";
      };

      rust = {
        format = "[$symbol ($version)]($style)";
        version_format = "\${major}.\${minor}";
        symbol = "";
      };

    };

  };
}

