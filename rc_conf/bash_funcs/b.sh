#!/usr/bin/env bash

# Go back x directories
function b() {
    str=""
    count=0
    if [ $# -eq 0 ];  then
        cd ..
    else
    while [ "$count" -lt "$1" ];
    do
        str=$str"../"
        let count=count+1
    done
    cd $str
    fi
}

