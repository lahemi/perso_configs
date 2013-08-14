#!/usr/bin/env bash

PREV_TOTAL=0
PREV_IDLE=0

while true; do
    CPU=$(awk 'NR' /proc/stat|awk '/^cpu / {print substr($0, index($0,$2))}')
    IDLE=$(echo $CPU|awk '{print $4}')
    # Calculate the total CPU time.
    FUN_TOTAL=$(echo $CPU|awk 'func sum(s) {
                                split(s,a);
                                r=0;
                                for(i in a) {
                                    r+=a[i];
                                }
                                return r}
                                {print sum($0)}')
    # Calculate the CPU usage since we last checked.
    let "DIFF_IDLE=$IDLE-$PREV_IDLE"
    let "DIFF_TOTAL=$FUN_TOTAL-$PREV_TOTAL"
    let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
    printf "\rCPU: %d%% \b\b" $DIFF_USAGE
    
    # Remember the total and idle CPU times for the next check.
    PREV_TOTAL="$FUN_TOTAL"
    PREV_IDLE="$IDLE"

    sleep 1
done
