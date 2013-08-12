#!/usr/bin/env bash
# Small control script for Wacom Bamboo Pen & Touch

function wacom() {
    wac='Wacom Bamboo 16FG 4x5'
    wacp="$wac Pen stylus"
    case "$1" in
        re)
            xsetwacom --set "$wac Finger touch" touch off 
            xsetwacom --set "$wacp" mode relative
            return;;
        ror)
            xrandr -o right\
                && xsetwacom --set "$wacp" rotate ccw 
            return;;
        ron)
            xrandr -o normal\
                && xsetwacom --set "$wacp" rotate none
            return;;
        draw)
            xsetwacom --set "$wacp" mode absolute
            return;;
        *)
            printf "\$1=re|ror|ron|draw\n"
    esac 
}

