#!/usr/bin/mksh
# Small utility which allows us to queue both local files
# and streamable videos from the Interwebs for Mplayer.
# GPLv3, 2013, Lauri Peltomäki

target="$HOME/.mplayer/queuelist"
tmp="$HOME/.mplayer/queuetmp"

while true; do
    touch "$tmp"
    toplay=$(awk 'NR==1' "$target")
    awk '{if(NR!=1){print}}' "$target" > "$tmp"
    awk '1' "$tmp" > "$target"
    rm "$tmp"

    [[ "$toplay" = http* ]] &&
        toplay=$(quvi "$toplay"|\
            awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')
    print "$toplaye"

    mplayer "$toplay"

    [[ ! -s "$target" ]] && break
done
