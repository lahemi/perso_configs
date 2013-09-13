#!/usr/bin/env mksh
# Quvi is a wonderful tool, providing
# a replacement for the evils of flash.
# See project website for more information.
# <http://quvi.sourceforge.net/>

test $# -ne 1 && exit 1

# If more than one mplayer on, sound only on the first one.
test -n "$(ps xc|grep mplayer)" && pkill mplayer

# There might still be issues with url's containing
# characters that are special to the shell.
url=$(echo "$1"|\
    awk '/^http.*$/&&!/^.*feature.*$/ { print }
        !/^http/&&/^.*feature.*$/ {sub(/&feature.*$/,"");
        print "http://"$0 }
        !/^http/ { print "http://"$0 }
        /^.*feature.*$/ {sub(/&feature.*$/,""); print }')

mplayer $(quvi "$url"|awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')

