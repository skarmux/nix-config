{ config, pkgs, lib, ... }:
# This module is meant for people who use two or more YubiKeys, one primary
# and one ore more others for backup or that other bag to be carried around.
#
# Setting up a PIN for Yubikey:
# `ykman fido access change-pin`
# Setting up U2F
# `pamu2fcfg -u skarmux > ~/u2f_keys` (Asks for FIDO PIN)
# add other Yubikeys
# `pamu2fcfg -n >> ~/u2f_keys`
let
  inherit (lib) mkOption mkEnableOption types mkIf;
  cfg = config.yubico;
in
{
  ###############
  ### OPTIONS ###
  ###############
  
  options.yubico = {

    enable = mkEnableOption "Use YubiKeys.";

    authorizeSSH = mkEnableOption "Owner can use key(s) for ssh authentication.";

    passwordlessSudo = mkEnableOption "Owner can use key(s) for sudo authentication.";

    authenticatorApp = mkEnableOption "Install the `yubioath-flutter` GUI authenticator app for 2FA codes.";

    keys = mkOption {
      description = ''
        Physical YubiKey hardware token configurations. NOTE: When multiple keys
        are connected, the first one matching with one of this list will be used
        for the SSH symlink. Entries are prioritized.
      '';
      type = with types; attrsOf (submodule {
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
            description = "The user using the key. Has to be a valid username on the system.";
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
      example = {
        "12345678" = {
          serial = 12345678;
          owner = "user";
          ssh.public = ./path/to/id_ecdsa_sk.pub;
        };
      };
      default = { };
    };
  };

  ##############
  ### CONFIG ###
  ##############

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      yubikey-manager # cli `ykman` Manager Configuration Tool
    ] ++ (lib.optionals cfg.passwordlessSudo [
      pam_u2f
    ]) ++ (lib.optionals cfg.authenticatorApp [
      yubioath-flutter # gui Authenticator for Desktop
    ]);

    # Register each keys public SSH key to its owners SSH access
    users.users = lib.mapAttrs' (name: value: {
      name = value.owner;
      value = {
        openssh.authorizedKeys.keys = [
          (builtins.readFile value.ssh.public)
        ];
      };
    }) cfg.keys;

    home-manager.users = lib.mapAttrs' (name: value: {
      name = value.owner;
      value = {

        home.file.".config/Yubico/u2f_keys" = {
          enable = cfg.passwordlessSudo;
          text = "${value.owner}:" + lib.concatStringsSep ":" (builtins.map(key:
            cfg.keys."${key}".u2f
          ) (builtins.attrNames cfg.keys));
        };

        programs.ssh = {
          # Required for `services.yubikey-agent`
          extraConfig = ''
            AddKeysToAgent yes
          '';
          matchBlocks = {
            # Instruct SSH to use the `id_yubikey` symlink
            "yubikey-hosts" = {
              host = "gitlab.com github.com";
              identitiesOnly = true;
              # `id_yubikey` is a symlink to whichever of multiple
              # yubikeys is connected.
              identityFile = [ "~/.ssh/id_yubikey" ];
            };
          };
        };

      };
    }) cfg.keys;

    services = {

      yubikey-agent.enable = true; # SSH Agent

      pcscd.enable = true; # Smartcard functionality

      udev = {
        packages = with pkgs; [
          yubikey-personalization
        ];
        extraRules = let
          # Works for all key-owner users that have their home directory at the expected location at /home
          yubikey-ssh-symlink = pkgs.writeShellApplication {
            name = "yubikey-ssh-symlink";
            runtimeInputs = with pkgs; [
              findutils # `find`
              yubikey-manager # `ykman`
            ];
            # NOTE: `ykman` does not list serial keys in the order they were plugged in at! (I tested it~ 😇)
            text = ''
              # find /home/*/.ssh/ -type f \( -name 'id_yubikey' -o -name 'id_yubikey.pub' \) -exec rm {} +
              # Yes, I'm constructing a bash case-block with nix expressions. #meta
              while IFS= read -r serial; do
                case "$serial" in
                  ${lib.concatMapStrings (yubikey: ''
                    "${toString cfg.keys."${yubikey}".serial}")
                    owner="${cfg.keys."${yubikey}".owner}"
                    ssh_public="${cfg.keys."${yubikey}".ssh.public}"
                    ssh_private="${cfg.keys."${yubikey}".ssh.private}"
                    ;;
                  '') (builtins.attrNames cfg.keys)}
                  *) echo "WARNING: YubiKey ($serial) is not configured for SSH use."; continue ;;
                esac
                ln -fs "$ssh_public" "/home/$owner/.ssh/id_yubikey.pub"
                ln -fs "$ssh_private" "/home/$owner/.ssh/id_yubikey"
                exit 0 # done after the first matched serial key
              done < <(ykman list --serials)
            '';
          };
        in ''
          SUBSYSTEM=="usb", \
          ACTION=="add", \
          ATTR{idVendor}=="1050", \
          RUN+="${yubikey-ssh-symlink}/bin/yubikey-ssh-symlink"

          SUBSYSTEM=="hid", \
          ACTION=="remove", \
          ENV{HID_NAME}=="Yubico Yubi*", \
          RUN+="${yubikey-ssh-symlink}/bin/yubikey-ssh-symlink"
        '';
      };
    };

    programs = {

      yubikey-touch-detector.enable = lib.mkDefault true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
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
        login.u2fAuth = cfg.passwordlessSudo;
        sudo.u2fAuth = cfg.passwordlessSudo;
      };
      u2f = {
        enable = cfg.passwordlessSudo;
        settings.cue = cfg.passwordlessSudo;
      };
    };
  };
}
