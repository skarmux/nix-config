{ config, lib, pkgs, ... }:
{
  users.users.skarmux = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "i2c" # control connected devices
      "gamemode"
      "networkmanager"
    ];
    hashedPasswordFile = config.sops.secrets."users/skarmux".path;
  };

  home-manager.users.skarmux = {
    imports = [
      ../../../home/base.nix
      ../../../home/desktop.nix
      ../../../home/work.nix
      ../../../home/streaming.nix
    ];
    home = {
      username = "skarmux";
      stateVersion = config.system.stateVersion;
      file.".ssh/id_ed25519.pub" = {
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfSahJoIaxQ31rSXlDgm4OzdShZGFkTaGsgXsP+D1v/ pewku-deployment";
      };
    };
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "brave"
        "firefox"
        "discordptb"
      ];
      workspace = [
        # TODO: I want the TV to be "enabled" as soon as Steam gets started
        #       in big picture (-tenfoot) mode and only be used for that or
        #       fullscreen video content (detect with `movies/games` wayland
        #       tags?)
        "name:tv, monitor:${config.monitors.lgcx.port}"
        # Make TV screen only show fullscreen content (smart gaps)
        # NOTE: This is to reduce static content like borders to burning into OLED
        (lib.concatStringsSep ", " [
          "m[${config.monitors.lgcx.port}]"
          "default:true"
          "gapsout:0"
          "gapsin:0"
          "floating:0"
          "border:false"
          "rounding:false"
          "persistent:true"
        ])
      ];
    };
  };

  sops.secrets = {
    "users/skarmux".neededForUsers = true;
    # NOTE: I need a separate key for using `deploy-rs` for deployments
    #       on pewku, since `deploy-rs` does not play with the pinentry
    #       required by ssh authentication via yubikey.
    # FIXME: Replace with a password protected SSH key.
    "pewku-deployment" = {
      path = "/home/skarmux/.ssh/id_ed25519";
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };
  };
}