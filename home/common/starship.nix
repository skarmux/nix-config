{
  programs.starship = {
    
    enableNushellIntegration = true;

    settings = {

      format = ''
        $directory ($git_branch $git_status
        )(($java )($nodejs )($go )($zig )($php )($python )($rust )
        )$nix_shell$jobs$character
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

