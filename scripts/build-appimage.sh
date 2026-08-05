#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-${ROOT_DIR}/build-linux}"
APPDIR="${APPDIR:-${ROOT_DIR}/AppDir}"
DIST_DIR="${DIST_DIR:-${ROOT_DIR}/dist}"
CACHE_DIR="${CACHE_DIR:-${ROOT_DIR}/.cache/linuxdeploy}"
VERSION="${VERSION:-0.1.0.2}"
ARCH="${ARCH:-x86_64}"
OUTPUT_PATH="${DIST_DIR}/RocketLauncher2-${VERSION}-${ARCH}.AppImage"
ICON_PATH="${ROOT_DIR}/packaging/linux/rocketlauncher2.png"

[[ "$(uname -m)" == "x86_64" ]]
command -v convert >/dev/null
command -v xvfb-run >/dev/null

if [[ ! -x "${BUILD_DIR}/RocketLauncher2" || ! -f "${BUILD_DIR}/Makefile" ]]; then
    "${ROOT_DIR}/scripts/build-linux.sh" "${BUILD_DIR}"
fi

convert "${ROOT_DIR}/RocketLauncher2.ico[0]" \
    -filter point -resize 256x256 "${ICON_PATH}"

rm -rf "${APPDIR}" "${DIST_DIR}"
mkdir -p "${APPDIR}" "${DIST_DIR}" "${CACHE_DIR}"
make -C "${BUILD_DIR}" install INSTALL_ROOT="${APPDIR}"

LINUXDEPLOY="${LINUXDEPLOY:-${CACHE_DIR}/linuxdeploy-${ARCH}.AppImage}"
QT_PLUGIN="${QT_PLUGIN:-${CACHE_DIR}/linuxdeploy-plugin-qt-${ARCH}.AppImage}"

download()
{
    [[ -x "$2" ]] || {
        curl --fail --location --retry 3 --output "$2" "$1"
        chmod +x "$2"
    }
}

download \
    "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH}.AppImage" \
    "${LINUXDEPLOY}"
download \
    "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${ARCH}.AppImage" \
    "${QT_PLUGIN}"

ln -sfn "${QT_PLUGIN}" "${CACHE_DIR}/linuxdeploy-plugin-qt"

export APPIMAGE_EXTRACT_AND_RUN="${APPIMAGE_EXTRACT_AND_RUN:-1}"
export LDAI_OUTPUT="${OUTPUT_PATH}"
export PATH="${CACHE_DIR}:${PATH}"
export QMAKE="${QMAKE:-$(command -v qmake)}"

"${LINUXDEPLOY}" \
    --appdir "${APPDIR}" \
    --executable "${APPDIR}/usr/bin/RocketLauncher2" \
    --desktop-file "${ROOT_DIR}/packaging/linux/io.github.Hypnotoad90.RocketLauncher2.desktop" \
    --icon-file "${ICON_PATH}" \
    --plugin qt \
    --output appimage

chmod +x "${OUTPUT_PATH}"
ROCKETLAUNCHER2_SMOKE_TEST=1 \
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
    "${OUTPUT_PATH}" --appimage-extract-and-run

printf '%s\n' "${OUTPUT_PATH}"
