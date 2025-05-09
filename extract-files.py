#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import extract_utils.tools

extract_utils.tools.DEFAULT_PATCHELF_VERSION = '0_9'

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/lake',
    'device/motorola/msm8998-common',
    'hardware/qcom-caf/msm8998',
    'hardware/qcom-caf/wlan',
    'vendor/motorola/msm8998-common',
    'vendor/qcom/opensource/dataservices',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/charge_only_mode': blob_fixup()
        .add_needed('libmemset_shim.so'),
    'vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service-ets.rc': blob_fixup()
        .regex_replace('system input', 'system uhid input'),
    'vendor/lib/libmmcamera2_pproc_modules.so': blob_fixup()
        .binary_regex_replace(b'\x70\x72\x6F\x64\x75\x63\x74\x2E\x6D\x61\x6E\x75', b'\x70\x72\x6F\x64\x75\x63\x74\x2E\x6E\x6F\x70\x65'),
    'vendor/lib/libsensorndkbridge.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib64/vendor.qti.hardware.tui_comm@1.0.so': blob_fixup()
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so')
        .replace_needed('libutils.so', 'libutils-v32.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'lake',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, 'msm8998-common', module.vendor)
    utils.run()
