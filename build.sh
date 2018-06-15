#!/usr/bin/env bash
set -ev # suggested by travis

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
		zip -r9 ../build/GryTTY.love .
	else
		zip -r9 ../build/GryTTY.love . -x "$1"
	fi
	popd
}

if $BUILD_FOR_MAC ; then
	# delete old
	rm -rf ../bin/GryTTY.app
	rm -f ../bin/GryTTY_mac.zip

	# get required stuff
	wget -N "${LOVE_DOWNLOADS}${MAC_DOWNLOAD_FILE}"
	unzip -u "${MAC_DOWNLOAD_FILE}"

	# build new
	zip_and_exclude $WIN_FLAG_FILE
	mkdir GryTTY.app
	mv love.app/* GryTTY.app
	mv GryTTY.love GryTTY.app/Contents/Resources/
	# see https://love2d.org/wiki/Game_Distribution#Creating_a_Mac_OS_X_Application for what values need to be changed in Info.plist
	plutil -replace CFBundleIdentifier -string com.crass_sandwich.GryTTY GryTTY.app/Contents/Info.plist
	plutil -replace CFBundleName -string GryTTY GryTTY.app/Contents/Info.plist
	plutil -remove UTExportedTypeDeclarations GryTTY.app/Contents/Info.plist

	# move and compress
	mv GryTTY.app ../bin/GryTTY.app
	pushd ../bin/
	zip -r9 GryTTY_mac.zip GryTTY.app
	popd
fi

if $BUILD_FOR_WIN ; then
	# delete old
	rm -f ../bin/GryTTY_win32.zip

	# get required stuff
	wget -N "${LOVE_DOWNLOADS}${WIN_DOWNLOAD_FILE}"
	unzip -u "${WIN_DOWNLOAD_FILE}"
	WIN_FOLDER="${WIN_DOWNLOAD_FILE%.*}" # this just removes the zip extension

	# build new
	zip_and_exclude $MAC_FLAG_FILE
	rm -rf GryTTY_win32
	mkdir GryTTY_win32
	cat "${WIN_FOLDER}/love.exe" GryTTY.love > GryTTY_win32/GryTTY.exe
	mv "${WIN_FOLDER}"/*.dll GryTTY_win32
	mv "${WIN_FOLDER}/license.txt" GryTTY_win32

	# move and compress
	cp -r GryTTY_win32 ../bin
	pushd ../bin/
	zip -r9 GryTTY_win32.zip GryTTY_win32
	popd
fi

# cleanup
if $BUILD_FOR_WIN || $BUILD_FOR_MAC; then
	cd ..
fi
rm -f $WIN_FLAG_FILE $MAC_FLAG_FILE $DEBUG_FLAG_FILE
