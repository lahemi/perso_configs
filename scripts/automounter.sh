#!/usr/bin/env bash

if [[ "$UID" != 0 ]]; then
    echo 'Run root.'
    exit 1
fi

sam1="/mnt/sam1"
sam2="/mnt/sam2"
sam3="/mnt/sam3"
dev1="/dev/sda1"
dev2="/dev/sda2"
dev3="/dev/sda3"

winp="Windows/System32/config"

mkdir "$sam1"
mkdir "$sam2"
mkdir "$sam3"

mount -o ro "$dev1" "$sam1"
mount -o ro "$dev2" "$sam2"
mount -o ro "$dev3" "$sam3"

function tarrer {
    cp -r "$2"/"$winp" .    
    tar -cf "$1".tar config
}

# Tests if the needed dir exists, if so, copies over to pwd and tars them.
function ifExists {
    if [[ -d "$1"/"$winp" ]]; then
        echo 'Tarring..'
        tarrer "$2" "$1"
    fi
}

ifExists "$sam1" sam1
ifExists "$sam2" sam2
ifExists "$sam3" sam3

