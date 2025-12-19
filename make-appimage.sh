#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q system-monitoring-center | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/io.github.hakandundar34coding.system-monitoring-center.svg
export DESKTOP=/usr/share/applications/io.github.hakandundar34coding.system-monitoring-center.desktop # longest icon and desktop names ever
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_SYS_PYTHON=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0

# Deploy dependencies
quick-sharun \
	/usr/bin/system-monitoring-center \
	/usr/bin/usr/bin/amdgpu_top       \
	/usr/bin/xrandr                   \
	/usr/lib/libgirepository*

sed -i \
	-e '/^pkgdatadir/c\pkgdatadir = os.getenv("APPDIR", "/usr") + "/share/system-monitoring-center"' \
	-e '/^localedir/c\localedir = os.getenv("APPDIR", "/usr") + "/share/locale"' \
	-e '/import sys/a import os' \
	./AppDir/bin/system-monitoring-center

# Turn AppDir into AppImage
quick-sharun --make-appimage
