{ lib, config, ... }:
let
  inherit (lib) mkOption types mkIf mkEnableOption;

  cfg = config.font-profiles;

  mkFontOption = kind: {
    family = mkOption {
      type = types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = mkOption {
      type = types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
in
{
  options.font-profiles = {
    enable = mkEnableOption "Whether to enable font profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
    emoji = mkFontOption "emoji";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      cfg.monospace.package
      cfg.regular.package
    ];
  };
}
