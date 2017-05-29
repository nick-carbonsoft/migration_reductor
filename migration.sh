#!/bin/bash

set -eu

#shellcheck disable=SC1091
. /usr/local/Reductor/etc/const

ARCHIVE="/root/reductor_backup.tar.gz"
GREEN='\033[0;32m'
NC='\033[0m'

error(){
	echo "Произошла ошибка при создании архива."
	exit 2
}

backup(){
	local lists="/migration_lists.tar"
	local userinfo="/migration_userinfo.tar"
	local reg="/migration_reg.tar"
	local dump="/migration_dump.tar"
	local cache="/migration_cache.tar"
	local network="/migration_network.tar"

	find "$USERDIR" ! -name "*." ! -path "$USERDIR/backups*" | tail -n +2 | xargs tar cvf "$userinfo" || eror
	find "$LISTDIR" ! -name "*." ! -path "$LISTDIR/tmp*" | tail -n +2 | xargs tar cvf "$lists" || error
	find "/var/reg" ! -name "*." ! -path "/var/reg/.*" | tail -n +2 | xargs tar cvf "$reg" || error
	find "$CACHEDIR" ! -name "*." ! -path "$CACHEDIR/*snapshots*" | tail -n +2 | xargs tar cvf "$cache" || error
	find "$NETWORK_SCRIPTS" ! -name "*." -not -iwholename '*.git*' | tail -n +2 | xargs tar cvf "$network" || error
	tar cvf "$dump" "$SSLDIR/php/" || error
	tar zcvf "$ARCHIVE" "$lists" "$userinfo" "$reg" "$dump" "$cache" "$network" || error
}


main(){
	backup && echo -e "Создание архива успено завершено." \
		&& echo \
		&& echo "Теперь перенесите архив с настройками Carbon Reductor 7 на машину, где установлен Carbon Reductor 8." \
		&& echo -e "Архив находистся здесь: ${GREEN}$ARCHIVE${NC}" \
		&& echo \
		&& echo "Например: scp $ARCHIVE ROOT@IP-REDUCTOR:/"|| exit 3
	rm -f migration_*.tar
}


main
