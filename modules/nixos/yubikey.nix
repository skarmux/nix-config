{ config, pkgs, lib, ... }:
let
  inherit (lib) literalExample optionals concatStringsSep mapAttrsToList mkOption mkEnableOption types mkIf;
  cfg = config.yubikey;
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
        serial=$(ykman list | awk "{print $NF}")
        # If it got unplugged before we ran, just don't bother
        if [ -z "''$serial" ]; then
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
        echo "Creating links to ${config.home.homeDirectory}/.ssh/id_''${key_name}"
        ln -sf "${config.home.homeDirectory}/.ssh/id_''${key_name}" ${config.home.homeDirectory}/.ssh/id_yubikey
        ln -sf "${config.home.homeDirectory}/.ssh/id_''${key_name}.pub" ${config.home.homeDirectory}/.ssh/id_yubikey.pub
      '';
    };
  yubikey-down =
    pkgs.writeShellApplication {
      name = "yubikey-down";
      text = ''
        set -euo pipefail
        rm ${config.home.homeDirectory}/.ssh/id_yubikey
        rm ${config.home.homeDirectory}/.ssh/id_yubikey.pub
      '';
    };
in
{
  options.yubikey = {
    enable = mkEnableOption "Start using yubikeys for authentication";
    identifiers = mkOption {
      type = types.attrOf types.int;
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
    gpg = mkEnableOption "GPG and SSH";
    lockScreen = mkEnableOption "Locking the screen when a Yubikey is unplugged";
    smartcard = mkEnableOption "Use smartcard feature (CCID)";
    pam = mkEnableOption "Use pam feature";
    u2f = mkEnableOption "Use u2f login";
    ssh = mkEnableOption "Use yubikey for ssh authentication";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = lib.flatten [
      pkgs.yubioath-flutter # gui Authenticator for Desktop
      pkgs.yubikey-manager # cli `ykman` Manager Configuration Tool
      pkgs.yubikey-manager-qt # gui Manager Configuration Tool
      pkgs.pam_u2f # sudo authentication
    ] ++ (optionals cfg.ssh [
      yubikey-up
      yubikey-down
    ]);

    # services.yubikey-agent.enable = true;

    # security.pam = {
    #   sshAgentAuth.enable = true;
    #   u2f = {
    #     enable = true;
    #     settings = {
    #       cue = false; # Tells user they need to press the button
    #       authFile = "${homeDirectory}/.config/Yubico/u2f_keys";
    #     };
    #   };
    # };

    # GPG and SSH
    services.udev.packages = [
      pkgs.yubikey-personalization
    ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # pam_u2f (Universal 2-Factor)
    security.pam.services = mkIf cfg.u2f {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      # sude.sshAgentAuth = true; # Use SSH_AUTH_SOCK for sudo
    };

    # yubico-pam (Pluggable Authentication Modules)
    security.pam.yubico = mkIf cfg.pam {
      enable = true;
      debug = true;
      mode = "challenge-response";
      id = [ "12345678" ];
    };

    # Smartcard mode
    services.pcscd.enable = cfg.smartcard;
  
    services.udev.extraRules = builtins.concatStringsSep "/n" [ ]
    ++ (optionals cfg.ssh [''
      # Link/unlink ssh key on yubikey add/remove
      SUBSYSTEM=="usb",\
      ACTION=="add",\
      ATTR{idVendor}=="1050",\
      RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"

      SUBSYSTEM=="input",\
      ACTION=="remove",\
      ENV{HID_NAME}=="Yubi",\
      RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"
    ''])
    ++ (optionals cfg.lockScreen [''
      ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '']);
  };
}
