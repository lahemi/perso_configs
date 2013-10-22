#!/usr/bin/env mksh
# Should work on Bash as it is, too.

tput clear

scrollprint() {
    awk -vvar="$1" 'BEGIN {
        split(var,arr,"");
        for(i=1;i<=length(arr);i++) {
            printf arr[i];
            system("sleep 0.05");
        }
    }'
    printf "\n"
    sleep 0.3
}

scrollprint "        ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM"
scrollprint "          COPYRIGHT 2075-2077 ROBCO INDUSTRIES"
scrollprint "              Server  $(hostname)"

