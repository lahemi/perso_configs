#!/usr/bin/mksh

# b [count] instead of cd ../../../ ....
b() {
    str=""
    integer count=0
    test $# -eq 0 && cd ..
    test $# -gt 0 && \
        while test "$count" -lt "$1"; do
            str="$str../"
            let "count = count + 1"
        done
        cd "$str"
}
