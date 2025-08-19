{
  programs.starship = {

    enable = true;

    enableNushellIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    enableTransience = true;

    settings = {

      format = ''
        ($hostname )$directory ($git_branch $git_status
        )(($java )($nodejs )($go )($zig )($php )($python )($rust )
        )$nix_shell$jobs$shell$character
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
        format = "[$ssh_symbol$hostname]($style)";
        style = "bold fg:blue";
        ssh_only = true;
      };

      directory = {
        format = "[$path](bold blue)";
        # truncation_length = 0;
        # truncation_symbol = "󰉋 ";
        truncate_to_repo = true; # truncate git repos
        # home_symbol = "󰋜 ";
        # substitutions = {
        #   Documents = "󰈙 ";
        #   Downloads = " ";
        #   Music = "󰝚 ";
        #   Pictures = " ";
        # };
      };

      shell = {
        bash_indicator = "$_ ";
        fish_indicator = "󰈺 ";
        powershell_indicator = "_";
        unknown_indicator = "mystery shell";
        style = "cyan bold";
        disabled = false;
      };

      nix_shell = {
        format = "[$symbol]($style)";
        symbol = " ";
      };

      git_branch = {
        symbol = "";
        format = "[$symbol $branch(:$remote_branch)]($style)";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol ($version)]($style)";
        version_format = "\${major}.\${minor}";
        symbol = "";
      };
    };
  };
}

