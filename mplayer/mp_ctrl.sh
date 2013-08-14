#!/usr/bin/env bash

fifo="$HOME/.mplayer/mp_fifo"

fprint() {
    local str=""
    for i in "$@"; do
        str="$str ""$i"
    done
    printf "%s\n" "$str" > $fifo
}

[ "$1" = "q" ] && fprint 'quit'
[ "$1" = "n" ] && fprint 'pt_step 1'
[ "$1" = "p" ] && fprint 'pt_step -1'
[ "$1" = "s" ] && fprint 'seek ' "$2"
[ "$1" = "ps" ] && fprint 'pause'
