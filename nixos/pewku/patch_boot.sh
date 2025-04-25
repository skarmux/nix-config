#!/usr/bin/env bash

cd /mnt/boot
rm -rf ./**
# VERSION=v1.33
VERSION=v1.41
wget "https://github.com/pftf/RPi4/releases/download/$VERSION/RPi4_UEFI_Firmware_$VERSION.zip"
unzip "RPi4_UEFI_Firmware_$VERSION.zip"
rm -vi README.md
rm -vi "RPi4_UEFI_Firmware_$VERSION.zip"
