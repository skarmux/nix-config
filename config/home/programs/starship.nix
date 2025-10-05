{
  programs.starship = {

    enable = true;

    enableNushellIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    # Only working within the fish shell (for now)
    enableTransience = true;

    settings = {

      format = ''
        $hostname$directory$fill$nix_shell
        $jobs$character
      '';

      # right_format = ''
      # '';

      add_newline = false;

      hostname = {
        format = "[$ssh_symbol$hostname]($style)";
        style = "bold fg:blue";
        detect_env_vars = [ "SSH_CONNECTION" ];
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
        bash_indicator = "$ ";
        fish_indicator = "󰈺 ";
        nu_indicator = "❯ ";
        powershell_indicator = "_ ";
        unknown_indicator = "? ";
        style = "blue bold";
        disabled = false;
      };

      nix_shell = {
        format = "[$symbol](blue)";
        symbol = " ";
      };

      # git_state = { };

      # git_status = { };

      git_branch = {
        symbol = "";
        format = "[$branch(:$remote_branch)]($style)";
        style = "bold magenta";
      };

      rust = {
        format = "[$symbol ($version)]($style)";
        version_format = "\${major}.\${minor}";
        symbol = " ";
      };
    };
  };
}

