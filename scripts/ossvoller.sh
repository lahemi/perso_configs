#!/usr/bin/env bash
# Minor command line tool for more concise OSS volume adjusting.
# GPLv2, 2013, Lauri Peltomäki, <lahemi.maki"at"gmail.com>

# Adjust these variables to correspond with your system.
DEV="jack.green.front"
MUTE="jack.green.mute"


function usage() {
    printf "\
Usage: $0 <option> [argument]\n\n\
\t-i or --increase <number> to increase the volume by given amount.\n\
\t-d or --decrease <number> to decrease the volume by given amount.\n\
\t-t or --toggle to toggle mute on and off.\n\
\t-s or --setvol <number> to set the volume to the given level.\n\
\t-c or --current to view the current volume.\n\n\
Anything else will show this help text.\n"
}

# Get the current volume level, -d for decimal, -i for int.
function awk_vol() {
    case "$1" in
        -d)
            ossmix -c|\
                awk 'BEGIN{FS=":"} /'$DEV' / {printf $2}'
            return 0;;
        -i)
            ossmix -c|\
                awk 'BEGIN{FS="."} /'$DEV' / {printf substr($4,3,4)}'
            return 0;;
    esac
}

function toggle_mute() {
    VOLUME=$(ossmix -c|awk '/'$MUTE'/ {printf $NF}')

    if [[ "$VOLUME" = "OFF" ]]; then
        ossmix $MUTE ON
    else
        ossmix $MUTE OFF
    fi
}

function set_vol() {
    ossmix $DEV -- "$1"
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

function main() {
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
            usage
            return 0;;
    esac
}

main "$@"
