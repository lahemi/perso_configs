#!/usr/bin/mksh

target="$HOME/.mplayer/queuelist"
tmp="$HOME/.mplayer/queuetmp"

while true; do
    touch "$tmp"
    toplay=$(awk 'NR==1' "$target")
    awk '{if(NR!=1){print}}' "$target" > "$tmp"
    awk '1' "$tmp" > "$target"
    rm "$tmp"

    [[ "$toplay" = http* ]] &&
        toplay=$(quvi dump "$toplay"|\
            awk '/PROPERTY_URL/ {
                    match($0,/http.+/);
                    print(substr($0,RSTART,RLENGTH)) }')
    print "$toplay"
    # -rootwin as a dirty workaround for background playing.
    mplayer -fs "$toplay"

    [[ ! -s "$target" ]] && break
done
