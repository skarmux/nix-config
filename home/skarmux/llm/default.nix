{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.llm;
in
{
  options.programs.llm = {
    enable = mkEnableOption "Access large language models from the command-line";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.llm ];
    sops.secrets."keys.json" = {
      format = "json";
      sopsFile = ./keys.json;
      path = ".config/io.datasette.llm/keys.json";
      key = "";
    };
  };
}
