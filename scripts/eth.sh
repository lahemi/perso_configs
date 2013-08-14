#!/usr/bin/env bash

var=$(dmesg|awk '/renamed/ {print $NF}')

sed -i "s/enp2s0/$var/g" ~/.config/awesome/rc.lua

