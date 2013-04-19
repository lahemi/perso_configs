#!/usr/bin/env bash
# Quvi is a wonderful tool, providing of
# a workaround from the evils of flash.
# See project website for more information.
# <http://quvi.sourceforge.net/>

function qpl() {
    if [ $# != 1 ]; then
        echo 'Single arg, please.'
        return 1
    fi

    url="$1"

    if [[ "$url" != http* ]]; then
        url=$(echo "$url"|sed 's/^/http:\/\//')
        echo "$url"
    fi

    # If this happens to be the case, please quote arg.   
    if [[ "$url" == *feature* ]]; then
        url=$(echo "$url"|awk 'BEGIN{FS="&"} {print $1}')   
                                # or sed 's/\$[^$]*$//'
        echo "$url"
    fi

    mplayer $(quvi "$url"|awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')
}

