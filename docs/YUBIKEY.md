# Interfaces

## OTP (One-time password)
https://developers.yubico.com/OTP/

- Yubico OTP
- Challenge-response
- Static password
- OATH-HOTP

## FIDO2

# Setting up SSH
```sh
ykman --device SERIAL fido access change-pin --pin xxxxxx --new-pin xxxxxx
ssh-keygen -t ecdsa-sk -O resident -O verify-required -C "email or comment"
```
Store generated private key handle into corresponding SOPS secrets, ex. `sops /nixos/ignika/secrets.yml`.
Place generated public key into the flake repositore, ex, `/keys/KEY.pub`, and reference it in the configuration under user ssh authorized keys as well as my yubikey module that is setting up the automatic symlinking.

## FIDO U2F

## OpenPGP

## PIV (Personal Identity Verification)

Uses a private key on the hardware to decrypt RSA or ECC. Will be used for SSH connections most likely.

## OATH

# Keys

YubiKey 5C NFC (2468370) // USB Typ-C

# LUKS

Will require a `configuration slot` to be overwritten on given yubikey.

