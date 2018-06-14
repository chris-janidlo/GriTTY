#!/usr/bin/env bash

LOVE_DOWNLOADS="https://bitbucket.org/rude/love/downloads/"
MAC_DOWNLOAD_FILE="love-0.10.2-macosx-x64.zip"
WIN_DOWNLOAD_FILE="love-0.10.2-win32.zip"

COND="src/ConditionalCompilation/"
# this is where you define additional conditional flags
DEBUG_FLAG_FILE="${COND}debug"
MAC_FLAG_FILE="${COND}mac"
WIN_FLAG_FILE="${COND}win"

BUILD_FOR_MAC=false
BUILD_FOR_WIN=false

while getopts "dmw" opt; do
	case "$opt" in
	d)
		touch $DEBUG_FLAG_FILE
		;;
	m)
		touch $MAC_FLAG_FILE
		BUILD_FOR_MAC=true
		;;
	w)
		touch $WIN_FLAG_FILE
		BUILD_FOR_WIN=true
		;;
	esac
done

if $BUILD_FOR_WIN || $BUILD_FOR_MAC; then
	mkdir -p build bin
	cd build
fi

zip_and_exclude () {
	pushd ../src
	if [ -z "$1" ]; then
		zip -r9 ../build/GriTTY.love .
	else
		zip -r9 ../build/GriTTY.love . -x "$1"
	fi
	popd
}

if $BUILD_FOR_MAC ; then
	# delete old
	rm -rf ../bin/GriTTY.app
	rm -f ../bin/GriTTY_mac.zip

	# get required stuff
	wget -N "${LOVE_DOWNLOADS}${MAC_DOWNLOAD_FILE}"
	unzip -u "${MAC_DOWNLOAD_FILE}"

	# build new
	zip_and_exclude $WIN_FLAG_FILE
	mkdir GriTTY.app
	mv love.app/* GriTTY.app
	mv GriTTY.love GriTTY.app/Contents/Resources/
	# see https://love2d.org/wiki/Game_Distribution#Creating_a_Mac_OS_X_Application for what values need to be changed in Info.plist
	plutil -replace CFBundleIdentifier -string com.crass_sandwich.GriTTY GriTTY.app/Contents/Info.plist
	plutil -replace CFBundleName -string GriTTY GriTTY.app/Contents/Info.plist
	plutil -remove UTExportedTypeDeclarations GriTTY.app/Contents/Info.plist

	# move and compress
	mv GriTTY.app ../bin/GriTTY.app
	pushd ../bin/
	zip -r9 GriTTY_mac.zip GriTTY.app
	popd
fi

if $BUILD_FOR_WIN ; then
	# delete old
	rm -f ../bin/GriTTY_win32.zip

	# get required stuff
	wget -N "${LOVE_DOWNLOADS}${WIN_DOWNLOAD_FILE}"
	unzip -u "${WIN_DOWNLOAD_FILE}"
	WIN_FOLDER="${WIN_DOWNLOAD_FILE%.*}" # this just removes the zip extension

	# build new
	zip_and_exclude $MAC_FLAG_FILE
	rm -rf GriTTY_win32
	mkdir GriTTY_win32
	cat "${WIN_FOLDER}/love.exe" GriTTY.love > GriTTY_win32/GriTTY.exe
	mv "${WIN_FOLDER}"/*.dll GriTTY_win32
	mv "${WIN_FOLDER}/license.txt" GriTTY_win32

	# move and compress
	cp -r GriTTY_win32 ../bin
	pushd ../bin/
	zip -r9 GriTTY_win32.zip GriTTY_win32
	popd
fi

# cleanup
if $BUILD_FOR_WIN || $BUILD_FOR_MAC; then
	cd ..
fi
rm -f $WIN_FLAG_FILE $MAC_FLAG_FILE $DEBUG_FLAG_FILE
