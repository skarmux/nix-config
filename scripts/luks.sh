#!/usr/bin/env bash

# Source: https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS

# Automatic Setup
# Load shell environment for LUKS and Yubikey setup
nix-shell https://github.com/sgillespie/nixos-yubikey-luks/archive/master.tar.gz
