#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${1:-${ROOT_DIR}/build-linux}"
JOBS="${JOBS:-$(nproc)}"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

cd "${BUILD_DIR}"
qmake "${ROOT_DIR}/RocketLauncher2.pro" CONFIG+=release
make -j"${JOBS}"

QT_QPA_PLATFORM=offscreen \
ROCKETLAUNCHER2_SMOKE_TEST=1 \
"${BUILD_DIR}/RocketLauncher2"

printf 'Native Linux binary: %s\n' "${BUILD_DIR}/RocketLauncher2"
