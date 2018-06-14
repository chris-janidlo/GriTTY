#!/usr/bin/env bash

LOVE_DOWNLOADS="https://bitbucket.org/rude/love/downloads/"
MAC_DOWNLOAD_FILE="love-0.10.2-macosx-x64.zip"

COND="../src/ConditionalCompilation/"
WINDOWS_FLAG_FILE="${COND}windows"
MAC_FLAG_FILE="${COND}mac"
DEBUG_FLAG_FILE="${COND}debug"

BUILD_FOR_WINDOWS=false
BUILD_FOR_MAC=false

while getopts "dmw:" opt; do
	case "$opt" in
	d)
		touch $DEBUG_FLAG_FILE
		;;
	m)
		touch $MAC_FLAG_FILE
		BUILD_FOR_MAC=true
		;;
	w)
		touch $WINDOWS_FLAG_FILE
		BUILD_FOR_WINDOWS=trueXW
		;;
	esac
done

if $BUILD_FOR_WINDOWS || $BUILD_FOR_MAC; then
	mkdir -p bin build
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

# =============================================================================
# 									mac build
# =============================================================================
if $BUILD_FOR_MAC ; then
	# delete old
	rm -rf ../bin/GriTTY.app

	# build new
	zip_and_exclude $WINDOWS_FLAG_FILE
	wget -N "${LOVE_DOWNLOADS}${MAC_DOWNLOAD_FILE}"
	unzip -u "${MAC_DOWNLOAD_FILE}"
	mkdir GriTTY.app
	mv love.app/* GriTTY.app
	mv GriTTY.love GriTTY.app/Contents/Resources/
	cat ../res/Info.plist > GriTTY.app/Contents/Info.plist

	# done
	mv GriTTY.app ../bin
fi

# cleanup
rm -f $WINDOWS_FLAG_FILE $MAC_FLAG_FILE $DEBUG_FLAG_FILE
