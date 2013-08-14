#!/usr/bin/env bash
# Queue script for mplayer. Give a file as an argument,
# containing newline separated entries of multimedia files
# and|or youtube-urls. Should be rather trivial to extend
# to more sites than just youtube and|or replace quvi
# with youtube-dl or some such.

target="$1"
tmp="$HOME/playtmp.txt"

while true; do
    touch "$tmp"
    toplay=$(awk 'NR==1' "$target")
    awk '{if(NR!=1){print}}' "$target" > "$tmp"
    # Ugly, but unless we overwrite $target this way
    # and try to just $target > $target, it'll get
    # overwritten completely blank!
    awk 'NR' "$tmp" > "$target"
    rm "$tmp"

    [[ "$toplay" == *youtube* ]] && toplay=$(quvi "$toplay"|\
        awk 'BEGIN{FS="\""} /\"url\"/ {print $4}')

    mplayer "$toplay"

    [[ ! -s "$target" ]] && break
done

