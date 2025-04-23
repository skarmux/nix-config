#!/usr/bin/env bash

# pewku ip: 192.168.178.99

nix run github:nix-community/nixos-anywhere -- \
 --kexec "$(nix build --print-out-paths github:nix-community/nixos-images#packages.aarch64-linux.kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-aarch64-linux.tar.gz" \
 --flake 'github:skarmux/nix-config#pewku' \
 skarmux@192.168.178.99
