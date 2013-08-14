#!/usr/bin/env bash
# Quvi is a wonderful tool, providing
# a replacement for the evils of flash.
# See project website for more information.
# <http://quvi.sourceforge.net/>

[ $# != 1 ] && exit 1

url="$1"

[[ "$url" != http* ]] && \
    url=$(awk 'BEGIN{print "http://'"$url"'"}')

# For some reason mplayer hangs unless you quote url
# containing any of these pieces of madness.
[[ "$url" == *feature* ]] && \
    url=$(printf "$url"|awk 'BEGIN{FS="&"} {print $1}')

mplayer $(quvi "$url"|awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')

