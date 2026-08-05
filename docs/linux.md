# Linux

## Build

```sh
sudo apt-get update
sudo apt-get install appstream build-essential curl desktop-file-utils file imagemagick libfuse2 libgl1-mesa-dev qt5-qmake qtbase5-dev qttools5-dev-tools shellcheck xvfb
scripts/build-linux.sh
```

Output:

```text
build-linux/RocketLauncher2
```

## AppImage

```sh
scripts/build-appimage.sh
```

Output:

```text
dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
```

Run:

```sh
chmod +x dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
./dist/RocketLauncher2-0.1.0.2-x86_64.AppImage
```

UZDoom path:

```sh
find "$HOME" -type f -iname '*uzdoom*.AppImage' 2>/dev/null
```
