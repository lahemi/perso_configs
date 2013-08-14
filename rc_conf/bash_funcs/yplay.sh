#!/usr/bin/env bash
# youtube-dl is in public domain, under Unlicense.
# See <http://unlicense.org/> for more information.

# Good for storing those interesting lectures and such!
function yudl() {
    youtube-dl -t --extract-audio --audio-format=vorbis "$1"
}

# Sometimes they require visuals, too.
function yuvio() {
    youtube-dl -t --recode-video=ogg "$1"
}

# Avoid the evils of flash - stream to our favorite media player!
function ypl() {
    mplayer $(youtube-dl -g "$1")
}

