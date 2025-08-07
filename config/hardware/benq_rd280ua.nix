{ pkgs, config, lib, ... }:
let
  description = "BNQ BenQ RD280UA HAR0021601Q";
in
{
  # Allow switching the screen settings in hyprland
  environment.systemPackages = lib.mkIf config.programs.hyprland.enable [
    (pkgs.writeShellApplication {
      name = "monitor-movie";
      runtimeInputs = [ config.programs.hyprland.package ];
      text = ''
        hyprctl keyword monitor "desc:${description}, 3840x2160@23.98, 0x0, 1"
      '';
    })
    (pkgs.writeShellApplication {
      name = "monitor-std";
      runtimeInputs = [ config.programs.hyprland.package ];
      text = ''
        hyprctl keyword monitor "desc:${description}, 3840x2560@59.98, 0x0, 1"
      '';
    })
    (pkgs.writeShellApplication {
      name = "monitor-pal";
      runtimeInputs = [ config.programs.hyprland.package ];
      text = ''
        hyprctl keyword monitor "desc:${description}, 3840x2560@49.98, 0x0, 1"
      '';
    })
  ];

  monitors.benq = {
    desc = "BNQ BenQ RD280UA HAR0021601Q";
    width = 3840;
    height = 2560;
    refresh = 59.98;
  };
}