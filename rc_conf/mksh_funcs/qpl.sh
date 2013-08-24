#!/usr/bin/mksh

# Quvi can be used to replace flash on some sites. Liberate yourself!
qpl() {
    # First pattern tests for "well-formed" urls.
    # Second for the "worst case" case scenario.
    # Third and fourth deal with half-way there cases.
    # Note also, that if the url contains '&', it must be
    # quoted, since it's a special char for the shell!
    url=$(echo "$1"|\
        awk '/^http.*$/&&!/^.*feature.*$/ { print }
            !/^http/&&/^.*feature.*$/ {sub(/&feature.*$/,"");
                                       print "http://"$0 }
            !/^http/ { print "http://"$0 }
            /^.*feature.*$/ {sub(/&feature.*$/,""); print }')

    mplayer $(quvi "$url"|awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')
}

