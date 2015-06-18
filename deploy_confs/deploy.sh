#!/bin/sh

cwd=$(pwd)
confs="$cwd/confs"
target=$HOME

for f in "$confs"/*; do
    cp -r "$f" "$target/.${f##*/}"
done

