#!/usr/bin/env bash

# Explanation:
# For a raspberry pi to boot from an SSD, first we need to install official
# raspberry pi firmware and move the contenst of the sd-card to the attached
# ssd. Then, boot into a live image from USB and patch the boot partition on
# that ssd by downloading and extracting the contents for U-Boot raspberry pi
# firmware into it.

cd /mnt/boot
rm -rf ./**
# VERSION=v1.33
VERSION=v1.41
wget "https://github.com/pftf/RPi4/releases/download/$VERSION/RPi4_UEFI_Firmware_$VERSION.zip"
unzip "RPi4_UEFI_Firmware_$VERSION.zip"
rm -vi README.md
rm -vi "RPi4_UEFI_Firmware_$VERSION.zip"
