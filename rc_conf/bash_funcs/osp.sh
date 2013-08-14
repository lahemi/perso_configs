#!/usr/bin/env bash
# Minor command line tool for more concise OSS volume adjusting.
# GPLv2, 2013, Lauri Peltomäki, <lahemi.maki"at"gmail.com>

# Adjust these variables to correspond with your system.
DEV="jack.green.front"
MUTE="jack.green.mute"

# Get the current volume level, -d for xx.x, -i for int.
function awk_vol() {
    [ "$1" = "-d" ] && ossmix -c|\
        awk 'BEGIN{FS=":"} /'$DEV' / {printf $2}'
    [ "$1" = "-i" ] && ossmix -c|\
        awk 'BEGIN{FS="."} /'$DEV' / {printf substr($4,3,4)}'
}

function toggle_mute() {
    VOLUME=$(ossmix -c|awk '/'$MUTE'/ {printf $NF}')
    [ "$VOLUME" = "OFF" ] \
        && ossmix $MUTE ON || ossmix $MUTE OFF
}

function set_vol() {
    ossmix $DEV "$1"
}

function increase() {
    TMPVOL=$(awk_vol -i)
    let "SETVOL = $TMPVOL + $1 + 1"
    ossmix $DEV $SETVOL
}

function decrease() {
    TMPVOL=$(awk_vol -i)
    let "SETVOL = $TMPVOL - $1 + 1"
    ossmix $DEV $SETVOL
}

function osv() {
    case "$1" in
        '-i'|'--increase')
            increase "$2"
            return 0;;
        '-d'|'--decrease')
            decrease "$2"
            return 0;;
        '-s'|'--setvol')
            set_vol "$2"
            return 0;;
        '-t'|'--toggle')
            toggle_mute
            return 0;;
        '-c'|'--current')
            printf "%sdB\n" $(awk_vol -d)
            return 0;;
        *)
            return 0;;
    esac
}
