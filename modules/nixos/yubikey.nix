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
      find /home/*/.ssh/ -type f \( -name 'id_yubikey' -o -name 'id_yubikey.pub' \) -exec rm {} +
      while IFS= read -r serial; do
        case "$serial" in
          ${lib.concatMapStrings (yubikey: ''
            "${toString yubikey.serial}")
            ssh_private="${yubikey.privateKeyFile}"
            ssh_public="${yubikey.publicKeyFile}"
            owner="${yubikey.owner}"
            ;;
          '') cfg.keys}
          *) echo "WARNING: YubiKey ($serial) is not configured for SSH use."; continue ;;
        esac
        ln -s "$ssh_public" "/home/$owner/.ssh/id_yubikey.pub"
        ln -s "$ssh_private" "/home/$owner/.ssh/id_yubikey"
        exit 0 # done after the first matched serial key
      done < <(ykman list --serials)
    '';
  };
in
{
  options.yubico = {
    enable = mkEnableOption "Start using yubikeys for authentication";
    # lockSession = mkEnableOption "Automatically lock session when yubikey is removed.";
    keys = mkOption {
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
          # TODO: Move those file options into an `ssh` submodule?
          publicKeyFile = mkOption {
            type = types.path;
            description =  ''
              Path to the public key file.
            '';
          };
          privateKeyFile = mkOption {
            type = types.path;
            description = ''
              Path to where the private key is stored. Note that the private key 
              only works in conjunction with the hardware key.
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

    services = {
      yubikey-agent.enable = true; # SSH Agent
      pcscd.enable = true; # Smartcard functionality
      udev = {
        packages = with pkgs; [
          yubikey-personalization
        ];
        # Mai 10 21:41:20 ignika kernel: usb 3-3.1.2: USB disconnect, device number 42
        # Mai 10 21:41:20 ignika acpid[1365]: input device has been disconnected, fd 25
        # Mai 10 21:41:21 ignika systemd[2013]: Stopped target Smart Card.
        # Mai 10 21:41:21 ignika systemd[1]: Stopped target Smart Card.
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
        # Passwordless sudo when SSH'ing with keys
        authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
      };
      # u2f = {
      #   enable = true;
      #   settings = {
      #     cue = false; # Tells user they need to press the button
      #     authFile = "/home/skarmux/.config/Yubico/u2f_keys";
      #     debug = false;
      #   };
      # };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          # login / sudo
          # NOTE: We use rssh because sshAgentAuth is old and doesn't support yubikey:
          # https://github.com/jbeverly/pam_ssh_agent_auth/issues/23
          # https://github.com/z4yx/pam_rssh
          rules.auth.rssh = {
            order =  config.rules.auth.ssh_agent_auth.order - 1;
            control = "sufficient";
            modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
            settings.authorized_keys_command = pkgs.writeShellApplication {
              name = "get-authorized-keys";
              runtimeInputs = with pkgs; [ coreutils ];
              text = ''
                cat "/etc/ssh/authorized_keys.d/$1"
              '';
            };
          };
        };
      };
    };
  };
}
