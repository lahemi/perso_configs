#!/usr/bin/awk -f

function scrollprint(str) {
    split(str,arr,"");
    for(i=1;i<=length(arr);i++) {
        printf arr[i];
        system("sleep 0.05");
    }
    printf "\n";
    system("sleep 0.3");
}

BEGIN {
    system("tput clear");

    cmd = "hostname";
    cmd|getline hostname;
    close(cmd);
    
    scrollprint("        ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM");
    scrollprint("          COPYRIGHT 2075-2077 ROBCO INDUSTRIES");
    scrollprint("              Server  " hostname);
}

