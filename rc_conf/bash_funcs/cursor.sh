#!/usr/bin/env bash
# Small utility script for moving the mouse pointer with keyboard.
# Very primitive at the moment. Only crude movement and first click.
# Fell asleep in the middle of writing this.

dopmov() {
    # 2>/dev/null is because of xdotools debug flag,
    # silencing 'findclient' from printing to stderr.
    xloc=$(xdotool getmouselocation --shell 2>/dev/null|\
        awk '/X/ {print(substr($0,3))}')
    yloc=$(xdotool getmouselocation --shell 2>/dev/null|\
        awk '/Y/ {print(substr($0,3))}')

    let "x = $xloc + $1"
    let "y = $yloc + $2"

    #swarp $x $y
    xdotool mousemove $x $y
}

pmov() {
    [ "$1" = "h" ] && dopmov -20 0
    [ "$1" = "j" ] && dopmov 0 20
    [ "$1" = "k" ] && dopmov 0 -20
    [ "$1" = "l" ] && dopmov 20 0
    [ "$1" = "spc" ] && xdotool click 1
}

pmov "$1"
