#!/bin/bash

ROOT="${PWD}"

ASB=(
)

REPOSITORIES=(
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

