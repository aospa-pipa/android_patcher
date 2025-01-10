#!/bin/bash

ROOT="${PWD}"

ASB=(
    'build/release'
    'external/skia'
    'frameworks/base'
    'frameworks/native'
    'packages/apps/DocumentsUI'
    'packages/apps/Settings'
    'packages/modules/Bluetooth'
    'packages/modules/Permission'
    'packages/modules/Wifi'
    'packages/providers/MediaProvider'
)

REPOSITORIES=(
    'bootable/recovery'
    'build/make'
    'build/soong'
    'device/qcom/common'
    'external/kotlinc'
    'external/kotlinx.coroutines'
    'external/kotlinx.serialization'
    'frameworks/av'
    'frameworks/base'
    'kernel/msm-4.19'
    'hardware/qcom/media'
    'packages/apps/LMOFreeform'
    'packages/apps/ParanoidSense'
    'packages/apps/ParanoidSettings'
    'packages/apps/Settings'
    'system/sepolicy'
    'vendor/qcom/common'
    'vendor/qcom/opensource/usb'
)

for repository in "${ASB[@]}"; do
    cd "${ROOT}/${repository}"

    git am --keep-cr "${ROOT}/patcher/asb/${repository}"/*.patch >/dev/null 2>&1

    if [ $? != 0 ]; then
        echo "==============================================="
        echo "[ASB] Failed to patch: ${repository}"
        echo "==============================================="
        git am --abort >/dev/null 2>&1
    fi

    cd "${ROOT}"
done

for repository in "${REPOSITORIES[@]}"; do
    cd "${ROOT}/${repository}"

    git am --keep-cr "${ROOT}/patcher/aospa/${repository}"/*.patch >/dev/null 2>&1

    if [ $? != 0 ]; then
        echo "==============================================="
        echo "Failed to patch: ${repository}"
        echo "==============================================="
        git am --abort >/dev/null 2>&1
    fi

    cd "${ROOT}"
done
