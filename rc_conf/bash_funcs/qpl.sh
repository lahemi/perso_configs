#!/usr/bin/env bash
# Quvi is a wonderful tool, providing of
# a replacement for the evils of flash.
# See project website for more information.
# <http://quvi.sourceforge.net/>

function qpl() {
    if [ "$1" == "null" ]; then
        opt='-vo null'
        url="$2"
    else
        opt=""
        url="$1"
    fi

    if [[ "$url" != http* ]]; then
        url=$(printf "$url"|sed 's/^/http:\/\//')
    fi

    # TODO check quoting
    if [[ "$url" == *feature* ]]; then
        url=$(printf "$url"|\
            awk 'BEGIN{FS="&"} {print $1}')
    fi

    mplayer $opt $(quvi "$url"|\
        awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')
}

