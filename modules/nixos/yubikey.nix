# This module is meant for people who use two or more YubiKeys, one primary
# and one ore more others for backup or that other bag to be carried around.
#
# Setting up a PIN for Yubikey:
# `ykman fido access change-pin`
# Setting up U2F
# `pamu2fcfg -u skarmux > ~/u2f_keys` (Asks for FIDO PIN)
# add other Yubikeys
# `pamu2fcfg -n >> ~/u2f_keys`
#
# TODO: Using multiple yubikeys at the same time (for different purposes?)
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types mkIf;

  cfg = config.yubico;

  yubikey-ssh-symlink = pkgs.writeShellApplication {
    name = "yubikey-ssh-symlink";
    runtimeInputs = with pkgs; [
      findutils # `find`
      yubikey-manager # `ykman`
    ];
    # NOTE: `ykman` does not list serial keys in the order they were plugged in at! (I tested it~ 😇)
    text = ''
      # find /home/*/.ssh/ -type f \( -name 'id_yubikey' -o -name 'id_yubikey.pub' \) -exec rm {} +
      while IFS= read -r serial; do
        case "$serial" in
          ${lib.concatMapStrings (yubikey: ''
            "${toString yubikey.serial}")
            ssh_private="${yubikey.ssh.private}"
            ssh_public="${yubikey.ssh.public}"
            owner="${yubikey.owner}"
            ;;
          '') cfg.keys}
          *) echo "WARNING: YubiKey ($serial) is not configured for SSH use."; continue ;;
        esac
        ln -fs "$ssh_public" "/home/$owner/.ssh/id_yubikey.pub"
        ln -fs "$ssh_private" "/home/$owner/.ssh/id_yubikey"
        exit 0 # done after the first matched serial key
      done < <(ykman list --serials)
    '';
  };
in
{
  options.yubico = {
    enable = mkEnableOption "Use YubiKeys.";
    # lockSession = mkEnableOption "Automatically lock session when yubikey is removed.";
    keys = mkOption {
      default = [ ];
      type = with types; listOf (submodule {
        options = {
          serial = mkOption {
            type = with types; nullOr int;
            description = ''
              The serial number for YubiKey 5 Series. Leave blank for `Security
              Key` devices which will report `[FIDO]` in place of a serial
              number.
            '';
          };
          owner = mkOption {
            type = types.str;
            description = "The user using the key.";
          };
          ssh.public = mkOption {
            type = types.path;
            description = ''
              Path to the public key file.
            '';
          };
          ssh.private = mkOption {
            type = types.path;
            description = ''
              Path to where the private key is stored. Note that the private key 
              only works in conjunction with the hardware key.
            '';
          };
          u2f = mkOption {
            type = types.str;
            description = ''
              Key for universal 2-factor authentication for passwordless sudo.
              Generate one using `pamu2fcfg`. Make sure to trim the `<username>:` prefix.
            '';
          };
        };
      });
      example = [{
        serial = 12345678;
        owner = "user";
      }];
      description = ''
        Physical YubiKey hardware token configurations. NOTE: When multiple keys
        are connected, the first one matching with one of this list will be used
        for the SSH symlink. Entries are prioritized.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      yubioath-flutter # gui Authenticator for Desktop
      yubikey-manager # cli `ykman` Manager Configuration Tool
      pam_u2f # sudo authentication
    ];

    home-manager.users.skarmux = {

      # TODO
      home.file.".config/Yubico/u2f_keys".text = "skarmux:" + lib.concatStringsSep ":" (builtins.map(key: key.u2f) cfg.keys);

      programs.ssh = {
        # Required for `services.yubikey-agent`
        extraConfig = ''
          AddKeysToAgent yes
        '';
        matchBlocks = {
          # Instruct SSH to use the `id_yubikey` symlink
          "yubikey-hosts" = {
            host = "gitlab.com github.com pewku";
            identitiesOnly = true;
            # `id_yubikey` is a symlink to whichever of multiple
            # yubikeys is connected.
            identityFile = [ "~/.ssh/id_yubikey" ];
          };
        };
      };

    };

    services = {
      yubikey-agent.enable = true; # SSH Agent
      pcscd.enable = true; # Smartcard functionality
      udev = {
        packages = with pkgs; [
          yubikey-personalization
        ];
        extraRules = ''
          SUBSYSTEM=="usb", \
          ACTION=="add", \
          ATTR{idVendor}=="1050", \
          RUN+="${yubikey-ssh-symlink}/bin/yubikey-ssh-symlink"

          SUBSYSTEM=="hid", \
          ACTION=="remove", \
          ENV{HID_NAME}=="Yubico Yubi*", \
          RUN+="${yubikey-ssh-symlink}/bin/yubikey-ssh-symlink"
        '';
        # '' ++ (lib.optional cfg.lockSession ''
        #   ACTION=="remove",\
        #   ENV{ID_BUS}=="usb",\
        #   ENV{ID_MODEL_ID}=="0407",\
        #   ENV{ID_VENDOR_ID}=="1050",\
        #   ENV{ID_VENDOR}=="Yubico",\
        #   RUN+="loginctl lock-sessions"
        # '');
      };
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Pluggable Authentication Modules (PAM)
    security.pam = {
      sshAgentAuth = {
        enable = true;
        # Passwordless sudo when SSH'ing into remote
        authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
      };
      # Login/sudo with yubikeys
      # FIXME: The symlinking job might need to run in order for both keys to work
      #        for the sddm login.
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      u2f = {
        enable = true;
        settings.cue = true;
      };
    };
  };
}
