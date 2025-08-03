{ config, lib, ... }:
{
  yubico = {
  
    enable = true;
    authorizeSSH = lib.mkDefault true;

    keys = {

      #############################################
      ### YubiKey 5 NFC (5.4.3) [OTP+FIDO+CCID] ###
      #############################################
      
      "25390376" = {
        serial = 25390376;
        owner = "skarmux";
        ssh.public = ./id_ecdsa_yk_25390376.pub;
        ssh.private = config.sops.secrets."25390376/id_ecdsa_sk".path;
        u2f = lib.concatStringsSep "," [
          "HoxTlnSB0PGZXufQTIev0WrAEmAvuFrIfJHUsIBlIfLNAyXuXXvTfCgVHjYFl/uFzQ5na8lYhS7aI5OtrQHTOg=="
          "74dG2GAw/mveqaGg3C2tKq67shzOi3U4U8nMrCZFXh9ntIEViCzVm8Ejx4gL15t1zJGlUbUAwEQ+aJl9thmXeA=="
          "es256"
          "+presence"
        ];
      };

      ##########################################
      ### YubiKey 5C (5.7.4) [OTP+FIDO+CCID] ###
      ##########################################
      
      "32885183" = {
        serial = 32885183;
        owner = "skarmux";
        ssh.public = ./id_ecdsa_yk_32885183.pub;
        ssh.private = config.sops.secrets."32885183/id_ecdsa_sk".path;
        u2f = lib.concatStringsSep "," [
          "bBrr/5QkqBoMZ91LCaP3V5bAAfPV83uag4WzeoR/16KvLEm0dma/NTMonTbMugp3mNbAeT3ENFwQepSt2t/pBA=="
          "2seG9qJCoCmvrLoOkMNX/QuCyj5Ick7syv67kV2Yn6U5U1iuoJPbm+S9+mqredmBpj7aPCeON/J7GiHv63GV+A=="
          "es256"
          "+presence"
        ];
      };

    };
  };
  
  # The ISO image won't have SOPS enabled and uses the yubico module for enabling
  # all of the required services for working with yubikeys. The private keys can
  # be installed with running `ssh-keygen -K` while a yubikey is plugged in.

  sops.secrets = {

    "25390376/id_ecdsa_sk" = {
      sopsFile = ./secrets.yaml;
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };

    "32885183/id_ecdsa_sk" = {
      sopsFile = ./secrets.yaml;
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };

  };

}