#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-${ROOT_DIR}/build-linux}"
APPDIR="${APPDIR:-${ROOT_DIR}/AppDir}"
DIST_DIR="${DIST_DIR:-${ROOT_DIR}/dist}"
CACHE_DIR="${CACHE_DIR:-${ROOT_DIR}/.cache/linuxdeploy}"
VERSION="${VERSION:-0.1.0.2}"
ARCH="${ARCH:-x86_64}"
OUTPUT_NAME="RocketLauncher2-${VERSION}-${ARCH}.AppImage"

if [[ "$(uname -m)" != "x86_64" ]]; then
    printf 'AppImage packaging currently supports x86_64 hosts only.\n' >&2
    exit 1
fi

"${ROOT_DIR}/scripts/build-linux.sh" "${BUILD_DIR}"

rm -rf "${APPDIR}" "${DIST_DIR}"
mkdir -p "${APPDIR}" "${DIST_DIR}" "${CACHE_DIR}"

make -C "${BUILD_DIR}" install INSTALL_ROOT="${APPDIR}"

LINUXDEPLOY="${LINUXDEPLOY:-${CACHE_DIR}/linuxdeploy-${ARCH}.AppImage}"
QT_PLUGIN="${QT_PLUGIN:-${CACHE_DIR}/linuxdeploy-plugin-qt-${ARCH}.AppImage}"

download_tool()
{
    local url="$1"
    local destination="$2"

    if [[ -x "${destination}" ]]; then
        return
    fi

    curl --fail --location --retry 3 --output "${destination}" "${url}"
    chmod +x "${destination}"
}

download_tool \
    "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH}.AppImage" \
    "${LINUXDEPLOY}"

download_tool \
    "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${ARCH}.AppImage" \
    "${QT_PLUGIN}"

export APPIMAGE_EXTRACT_AND_RUN="${APPIMAGE_EXTRACT_AND_RUN:-1}"
export OUTPUT="${DIST_DIR}/${OUTPUT_NAME}"
export QMAKE="${QMAKE:-$(command -v qmake)}"

"${QT_PLUGIN}" --appdir "${APPDIR}"

"${LINUXDEPLOY}" \
    --appdir "${APPDIR}" \
    --executable "${APPDIR}/usr/bin/RocketLauncher2" \
    --desktop-file "${ROOT_DIR}/packaging/linux/io.github.Hypnotoad90.RocketLauncher2.desktop" \
    --icon-file "${ROOT_DIR}/packaging/linux/rocketlauncher2.svg" \
    --output appimage

chmod +x "${OUTPUT}"

QT_QPA_PLATFORM=offscreen \
ROCKETLAUNCHER2_SMOKE_TEST=1 \
"${OUTPUT}" --appimage-extract-and-run

printf 'Linux AppImage: %s\n' "${OUTPUT}"
