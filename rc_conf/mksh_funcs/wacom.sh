#!/usr/bin/mksh

# VGA-1 is our main monitor. 
# We rather not rotate our IRC/nmon monitor.
wacom() {
    wac='Wacom Bamboo Connect'
    wacp="$wac Pen stylus"
    test "$1" = "re" && \
        xsetwacom --set "$wacp" mode relative
    test "$1" = "ror" && \
        xrandr --output VGA-1 --rotate right && \
        xsetwacom --set "$wacp" rotate ccw 
    test "$1" = "ron" && \
        xrandr --output VGA-1 --rotate normal && \
        xsetwacom --set "$wacp" rotate none
    test "$1" = "draw" && \
        xsetwacom --set "$wacp" mode absolute
}

