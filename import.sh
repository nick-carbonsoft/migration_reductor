#!/bin/bash

set -eu

#shellcheck disable=SC1091
. /app/reductor/usr/local/Reductor/etc/const
#shellcheck disable=SC1091
. /app/reductor/usr/local/Reductor/usr/share/menu_lib

if [ -d '/app/base/' ]; then
	PREFIX="/app/reductor"
else
	exit 2
fi

ARCHIVE="/root/reductor_backup.tar.gz"
RAW_ARCHIVE="/tmp/archive/"

unpack(){
	mkdir -p "$RAW_ARCHIVE"
	tar -xvf "$ARCHIVE" -C "$RAW_ARCHIVE"
	for file in migration_{cache,dump,lists,userinfo,reg,network}; do
		tar -xvf $RAW_ARCHIVE/$file.tar -C $RAW_ARCHIVE
		rm -rf $RAW_ARCHIVE/$file.tar
	done
}

merge_config(){
	local config7="$USERDIR/config"
	local config8="/app/reductor/cfg/config"
	#shellcheck disable=SC1090
	. $config8
	#shellcheck disable=SC1090
	. $config7
    #shellcheck disable=SC2154
	app['name']='Reductor'
    #shellcheck disable=SC2154
	filter['forbidden_log']='0'
	CONFIG="$config8" save_and_exit
}

decompose(){
	find "$RAW_ARCHIVE" -name "lists" -exec cp -av {} $DATADIR" \;
	unlink "$LISTDIR/https.resolv"
	find "$RAW_ARCHIVE" -name "cache" -exec cp -av {} $DATADIR" \;
	find "$RAW_ARCHIVE" -name "reg" -exec cp -av {} "$PREFIX/var" \;
	# Директори отличаются, поэтому копируем только содержимое
	find "$RAW_ARCHIVE" -name "php" -exec cp -av {} "$DATADIR/rkn/" \;
	mv "$DATADIR"/rkn/php/* "$DATADIR/rkn"
	rm -rvf "$DATADIR/rkn/php/"
	find "$RAW_ARCHIVE" -name "userinfo" ! -name "*config" -exec cp -av {} "$PREFIX/cfg" \;
	find "$RAW_ARCHIVE" -name "network-scripts" -exec cp -av {} "$NETWORK_SCRIPTS" \;
}

main(){
	unpack
	decompose
	merge_config
	rm -vrf "$RAW_ARCHIVE"
}

main
