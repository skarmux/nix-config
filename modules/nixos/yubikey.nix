# Setting up a PIN for Yubikey:
# `ykman fido access change-pin`
# Setting up U2F
# `pamu2fcfg -u skarmux > ~/u2f_keys` (Asks for FIDO PIN)
# add other Yubikeys
# `pamu2fcfg -n >> ~/u2f_keys`
{ config, pkgs, lib, ... }:
let
  inherit (lib) literalExample optionals concatStringsSep mapAttrsToList mkOption mkEnableOption types mkIf;
  
  cfg = config.yubikey;

  # FIXME Does not belong in a module!!!
  homeDirectory = "/home/skarmux";

  # yubikey-up/down will symlink the currently plugged in yubikey to the id_yubikey
  # ssh entry. That way, ssh won't try using a key that isn't plugged in.
  yubikey-up =
    let
      yubikeyIds = concatStringsSep " " (
        mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") config.yubikey.identifiers
      );
    in
    pkgs.writeShellApplication {
      name = "yubikey-up";
      runtimeInputs = builtins.attrValues { inherit (pkgs) gawk yubikey-manager; };
      text = ''
        set -euo pipefail
        
        serial=$(ykman list | awk '{print $NF}')
        # If it got unplugged before we ran, just don't bother
        if [ -z "$serial" ]; then
          exit 0
        fi
        
        declare -A serials=(${yubikeyIds})

        key_name=""
        for key in "''${!serials[@]}"; do
          if [[ $serial == "''${serials[$key]}" ]]; then
            key_name="$key"
          fi
        done

        if [ -z "$key_name" ]; then
          echo WARNING: Unidentified yubikey with serial "''${serial}". Won\'t link an SSH key.
          exit 0
        fi
        
        echo "Creating links to ${homeDirectory}/.ssh/id_''${key_name}"
        ln -sf "${homeDirectory}/.ssh/id_''${key_name}" ${homeDirectory}/.ssh/id_yubikey
        ln -sf "${homeDirectory}/.ssh/id_''${key_name}.pub" ${homeDirectory}/.ssh/id_yubikey.pub
      '';
    };

  yubikey-down =
    pkgs.writeShellApplication {
      name = "yubikey-down";
      text = ''
        set -euo pipefail
        rm ${homeDirectory}/.ssh/id_yubikey
        rm ${homeDirectory}/.ssh/id_yubikey.pub
      '';
    };
in
{
  options.yubikey = {
    enable = mkEnableOption "Start using yubikeys for authentication";
    lockScreen = mkEnableOption "Lock system when Yubikey is unplugged";
    identifiers = mkOption {
      type = types.attrsOf types.int;
      default = {};
      description = "Attrset of Yubikey serial numbers. NOTE: Yubico's 'Security Key' products do not use unique serial number therefore, the scripts in this module are unable to distinguish between multiple 'Security Key' devices and instead will detect a Security Key serial number as the string \"[FIDO]\". This means you can only use a single Security Key but can still mix it with YubiKey 4 and 5 devices.";
      example = literalExample ''
        {
          foo = 12345678;
          bar = 87654321;
          baz = "[FIDO]";
        }
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      # FIXME: Does not build
      # pkgs.yubioath-flutter # gui Authenticator for Desktop
      pkgs.yubikey-manager # cli `ykman` Manager Configuration Tool
      pkgs.pam_u2f # sudo authentication
      yubikey-up
      yubikey-down
    ];

    services = {
      yubikey-agent.enable = true; # SSH Agent
      pcscd.enable = true; # Smartcard functionality
      udev.packages = [ pkgs.yubikey-personalization ];
      # FIXME Screen locking on removal
      udev.extraRules = ''
        # Symlink ssh key on yubikey add
        SUBSYSTEM=="usb",\
        ACTION=="add",\
        ATTR{idVendor}=="1050",\
        RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"

        # Unlink ssh key on yubikey removal
        SUBSYSTEM=="hid",\
        ACTION=="remove",\
        ENV{HID_NAME}=="Yubico Yubi",\
        RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"

        # Lock screen when yubikey is unplugged
        # ACTION=="remove",\
        # ENV{ID_BUS}=="usb",\
        # ENV{ID_MODEL_ID}=="0407",\
        # ENV{ID_VENDOR_ID}=="1050",\
        # ENV{ID_VENDOR}=="Yubico",\
        # RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
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
      u2f = {
        enable = true;
        settings = {
          cue = false; # Tells user they need to press the button
          authFile = "/home/skarmux/.config/Yubico/u2f_keys";
          # debug = true;
        };
      };
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
            settings.authorized_keys_command = pkgs.writeShellScript "get-authorized-keys" ''
              cat "/etc/ssh/authorized_keys.d/$1"
            '';
          };
        };
      };
    };
  };
}
