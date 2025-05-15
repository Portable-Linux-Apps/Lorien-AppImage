#!/bin/sh

set -ex

export ARCH=$(uname -m)
REPO="https://api.github.com/repos/mbrlabs/Lorien/releases/latest"
APPIMAGETOOL="https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-$ARCH.AppImage"
UPINFO="gh-releases-zsync|$(echo $GITHUB_REPOSITORY | tr '/' '|')|latest|*$ARCH.AppImage.zsync"
DESKTOP="https://github.com/mbrlabs/Lorien/raw/refs/heads/main/public/linux/com.github.mbrlabs.Lorien.desktop"
ICON="https://github.com/mbrlabs/Lorien/raw/refs/heads/main/art/logo.svg"

tarball_url=$(wget "$REPO" -O - | sed 's/[()",{} ]/\n/g' \
	| grep -oi "https.*Linux.tar.xz" | head -1)

export VERSION=$(echo "$tarball_url" | awk -F'/' '{print $(NF-1); exit}')
echo "$VERSION" > ~/version

wget "$tarball_url" -O ./package.tar.xz
tar xvf ./package.tar.xz
rm -f ./package.tar.xz
mv -v ./Lorien* ./AppDir

ln -s Lorien."$(uname -m)" ./AppDir/AppRun
chmod +x ./AppDir/AppRun

wget "$DESKTOP" -O ./AppDir/Lorien.desktop
wget "$ICON" -O ./AppDir/com.github.mbrlabs.Lorien.svg
wget "$ICON" -O ./AppDir/.DirIcon

wget "$APPIMAGETOOL" -O ./appimagetool
chmod +x ./appimagetool
./appimagetool -n -u "$UPINFO" ./AppDir

