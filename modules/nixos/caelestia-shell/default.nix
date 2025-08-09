{ pkgs, lib, config, inputs, ... }:
#
# Credit goes to:
# https://quickshell.org/
# https://github.com/caelestia-dots/shell
#
# Caelestia-Shell manages:
# - Wallpaper
# - Taskbar
# - Wifi & Bluetooth
# - Custom Dashboard
# - Multimedia Controls
# - File Picker
# - Application Launcher
#
# TODO:
# - Make sure it's only used with Wayland, specifically Hyprland
let
  cfg = config.caelestia-shell;
  # package = pkgs.fetchFromGitHub {
  #   owner = "caelestia-dots";
  #   repo = "shell";
  #   rev = "master";
  #   hash = "";
  # };
in
{
  options.caelestia-shell = {

    enable = lib.mkEnableOption "Enable Caelestia-Shell";

    # package = lib.mkOption {
    #   default = inputs.caelestia-shell.packages.${pkgs.system}.default;
    # };

    # background = {
    #   enable = lib.mkEnableOption;
    #   path = lib.mkOption {
    #     type = lib.types.path;
    #     default = "~/Pictures/Wallpapers";
    #   };
    # };

    # https://github.com/caelestia-dots/shell/blob/main/default.nix
    # beat_detector needs installation
    # caelestia-shell is a wrapper for quickshell
    # --set FONTCONFIG_FILE ${fontconfig}
    # --add-flags '-p ${./.}

    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
             description = "Caelestia-Shell configuration value";
            };
        in
        valueType;
      default = { };
      description = "Caelestia-Shell configuration written in Nix.";
    };
  };

  config = lib.mkIf cfg.enable {

    home-manager.users.skarmux = {
      # home.file = {
      #   ".config/quickshell".source = ./quickshell;
      # };
      wayland.windowManager.hyprland = {
        settings = {
          # Launch quickshell asap
          exec-once = lib.mkBefore [
            # "quickshell --path \"${./quickshell}\""
            "quickshell"
          ];
        };
      };

    };

    qt.enable = true; # for languages server qmlls (Quickshell syntax)

    fonts.packages = with pkgs; [
      # https://fonts.google.com/icons
      material-symbols
      nerd-fonts.jetbrains-mono
    ];

    environment.systemPackages = with pkgs; [
      ddcutil # Query and change linux monitor settings
      brightnessctl # Control brightness (for laptop screens)
      # app2unit
      cava # Console-based audio visualizer for Alsa TODO: Pipewire?
      networkmanager
      # lm-sensors
      fish # Command-line shell
      aubio # Extraction of annotations from audio signals like pitch detection
      # libpipewire
      glibc
      # qt6-declarative
      # gcc-libs
      grim # Screenshot utility for wayland
      swappy # Edit screenshots from clipboard
      libqalculate # Advanced calculator library
    ] ++ [
      inputs.quickshell.packages.${pkgs.system}.default
      # cfg.package
    ];

  };
}