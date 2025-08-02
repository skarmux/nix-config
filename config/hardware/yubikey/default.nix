{ config, lib, ... }:
{
  yubico = {
    enable = true;
    keys = [
      #############################################
      ### YubiKey 5 NFC (5.4.3) [OTP+FIDO+CCID] ###
      #############################################
      
      # {
      #   serial = 24686370;
      #   owner = "skarmux";
      #   ssh = {
      #     public = ../../../keys/id_yc.pub;
      #     private = config.sops.secrets."yubico/ssh/yc".path;
      #   };
      #   u2f = lib.concatStringsSep "," [
      #     "L8qjIWOWGoj0solA3TySPcUw0eOS7ik7nuuleOBE+gX5aMpW6zV1Otbpt43fwwi4kCV+rUMe7Zd19FsLN1h6Gg=="
      #     "nIB1p7exghHOla/8H/YYE1+slFvcrU1dPOJHylpzr/DwgTji/evnANcwD9CRHJJ1ZkrwDSCRjw4yLn/Uq5rN/A=="
      #     "es256"
      #     "+presence"
      #   ];
      # }

      #############################################
      ### YubiKey 5 NFC (5.4.3) [OTP+FIDO+CCID] ###
      #############################################
      
      {
        serial = 25390376;
        owner = "skarmux";
        ssh = {
          public = ./id_ecdsa_yk_25390376.pub;
          private = config.sops.secrets."yubico/ssh/id_ecdsa_yk_25390376".path;
        };
        u2f = lib.concatStringsSep "," [
          "HoxTlnSB0PGZXufQTIev0WrAEmAvuFrIfJHUsIBlIfLNAyXuXXvTfCgVHjYFl/uFzQ5na8lYhS7aI5OtrQHTOg=="
          "74dG2GAw/mveqaGg3C2tKq67shzOi3U4U8nMrCZFXh9ntIEViCzVm8Ejx4gL15t1zJGlUbUAwEQ+aJl9thmXeA=="
          "es256"
          "+presence"
        ];
      }

      ##########################################
      ### YubiKey 5C (5.7.4) [OTP+FIDO+CCID] ###
      ##########################################
      
      {
        serial = 32885183;
        owner = "skarmux";
        ssh = {
          public = ./id_ecdsa_yk_32885183.pub;
          private = config.sops.secrets."yubico/ssh/id_ecdsa_yk_32885183".path;
        };
        u2f = lib.concatStringsSep "," [
          "bBrr/5QkqBoMZ91LCaP3V5bAAfPV83uag4WzeoR/16KvLEm0dma/NTMonTbMugp3mNbAeT3ENFwQepSt2t/pBA=="
          "2seG9qJCoCmvrLoOkMNX/QuCyj5Ick7syv67kV2Yn6U5U1iuoJPbm+S9+mqredmBpj7aPCeON/J7GiHv63GV+A=="
          "es256"
          "+presence"
        ];
      }
    ];
  };
  
  users.users.skarmux = {
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./id_ecdsa_yk_32885183.pub)
      (builtins.readFile ./id_ecdsa_yk_25390376.pub)
    ];
  };

  programs.yubikey-touch-detector.enable = lib.mkDefault true;

  sops.secrets = {

    "yubico/ssh/id_ecdsa_yk_25390376" = {
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };

    "yubico/ssh/id_ecdsa_yk_32885183" = {
      mode = "400";
      owner = "skarmux";
      group = config.users.users.skarmux.group;
    };

  };
}