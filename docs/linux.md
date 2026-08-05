# Linux build and packaging

Rocket Launcher 2.0 is a Qt 5 application. The repository now provides a native Linux build script and an x86_64 AppImage packaging script.

## Install build dependencies

Debian, Ubuntu and Linux Mint:

```sh
sudo apt-get update
sudo apt-get install \
  build-essential \
  curl \
  file \
  libfuse2 \
  libgl1-mesa-dev \
  qt5-qmake \
  qtbase5-dev \
  qttools5-dev-tools
```

`libfuse2` is needed to mount AppImages normally. The generated AppImage can also run without FUSE by passing `--appimage-extract-and-run`.

## Build the native binary

From the repository root:

```sh
scripts/build-linux.sh
```

The resulting executable is:

```text
build-linux/RocketLauncher2
```

The script performs an offscreen startup smoke test after compilation.

## Build the AppImage

From the repository root:

```sh
scripts/build-appimage.sh
```

The packaging script downloads `linuxdeploy` and its Qt plugin into `.cache/linuxdeploy`, creates an `AppDir`, and writes the finished package to:

```text
dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
```

Run it with:

```sh
chmod +x dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
./dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
```

Without FUSE:

```sh
./dist/RocketLauncher2-0.1.0.2-x86_64.AppImage --appimage-extract-and-run
```

## Select a source port on Linux

Rocket Launcher expects the executable itself, not a desktop shortcut. For a package installed by the distribution, locate the executable with:

```sh
command -v gzdoom
```

A typical result is:

```text
/usr/bin/gzdoom
```

Select that file in **Engine Setup → Detect from File**. Locally compiled source ports can be selected by browsing to their executable output.

## Configuration files

Qt stores Rocket Launcher settings under the user's configuration directory. On a typical Linux desktop these files are under:

```text
~/.config/RocketLauncher2/
```

This includes engine definitions, the selected IWAD list, favorites and saved launcher configurations.

## Continuous integration

`.github/workflows/linux-appimage.yml` builds on Ubuntu 22.04, runs the native and AppImage smoke tests, records a SHA-256 checksum, and uploads the AppImage as the `RocketLauncher2-linux-x86_64` workflow artifact.
