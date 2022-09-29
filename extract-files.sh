#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        # Add uhid group for fingerprint service
        vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service-ets.rc)
            sed -i "s/system input/system uhid input/" "${2}"
            ;;
        # Fix camera recording
        vendor/lib/libmmcamera2_pproc_modules.so)
            sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${2}"
            ;;
        # Use VNDK 32 libutils
        vendor/lib/hw/audio.primary.sdm660.so | vendor/lib/libmotaudioutils.so | vendor/lib/libsensorndkbridge.so | vendor/lib/libtinycompress_vendor.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib/soundfx/libspeakerbundle.so | vendor/lib/soundfx/libmmieffectswrapper.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=lake
export DEVICE_COMMON=sdm660-common
export VENDOR=motorola

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
