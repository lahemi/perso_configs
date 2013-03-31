#!/usr/bin/env bash
# Usage: eg. sudo ./$0 sdxX
# where sdx is the name of the device, and X is the number, as in sda1.
# Root is needed for mounting and accessing files on other partitions.
# This script is provided 'as-is', as usual.
# You are fully entitled to modify, distribute and elaborate on
# it as you please.

if [[ "$UID" != 0 ]]; then
    echo "Please run root."
    exit 1
fi

if [[ $# != 1 ]]; then
    echo "Please input device, eg. sda1"
    exit 1
fi

# Enabling extended globbing, for convenience.
shopt -s extglob

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

BKPATH="/mnt/pit"
BKD="backups/$YEAR/$MONTH/$DAY"
BKDIR="$BKPATH"/"$BKD"
if [[ ! -d "$BKDIR" ]]; then
    mkdir -p $BKDIR
fi

PNUM="$1"
DRIVE="/dev/"
BCKPATH="/mnt/bck"
if ! grep -qs $DRIVE$PNUM /proc/mounts; then
    if [[ ! -d $BCKPATH ]]; then
        mkdir $BCKPATH
    fi
    mount $DRIVE$PNUM $BCKPATH
fi

# What to back up, adjust accordingly.
BACKUP=('etc')

# Create an empty file for the log file, making sure it can be made.
BKLOG="$BKDIR/$(date +%d).log"
touch $BKLOG
echo -e "Generated backup report for $(uname -nro) on $YEAR.$MONTH.$DAY\n" >> $BKLOG
echo -e "Backup for: $YEAR.$MONTH.$DAY started @ $(date +%H:%M:%S)\n" >> $BKLOG

# Checks to see if day == 1, and if so, backs up the last month's backups
# Fails with January?
if [[ "$DAY" == "01" ]]; then
    M=$(echo -n $MONTH|awk '{printf substr($1,2)}')
    let OLD=M-1

    echo "New month detected. Backing up previous month\'s ($OLD) backups." >> $BKLOG
    echo "Backup file: /backups/$YEAR/$OLD.tar.gz" >> $BKLOG

    SD=$( { time tar -cpPvzf $BKPATH/backups/$YEAR/$OLD.tar.gz $BKPATH/backups/$YEAR/$OLD/; } 2>&1 )

    # Got stats, delete folder
    rm -rf $BKPATH/backups/$YEAR/$OLD

    SD=$(echo -n "$SD"|grep real)
    MIN=$(echo -n "$SD"|awk '{printf substr($2,0,2)}')
    SEC=$(echo -n "$SD"|awk '{printf substr($2,3)}')
    echo -e "- done [ $MIN $SEC ].\n" >> $BKLOG
fi

echo -e " Backing up $DRIVE$PNUM\n" >> $BKLOG

# Magicks
for d in "${BACKUP[@]}"; do
    echo -e " Backing up $d" >> $BKLOG
    SD=$( { time tar -cpPvzf $BKDIR/$d.tar.gz $BCKPATH/$d; } 2>&1 )
    SD=$(echo -n "$SD"|grep real)
    MIN=$(echo -n "$SD"|awk '{printf substr($2,0,2)}')
    SEC=$(echo -n "$SD"|awk '{printf substr($2,3)}')
    echo -e "- done [ $MIN $SEC ].\n" >> $BKLOG
done

# Bringing it all together and cleansing the evils.
cd $BKDIR && tar -cpPvzf "$BKDIR"/$(date +%Y-%m-%d).tar.gz ./*
for d in "${BACKUP[@]}"; do
    rm -f $BKDIR/$d.tar.gz
done
umount $DRIVE$PNUM
rm -rf $BCKPATH
cat "$BKLOG"
rm -f "$BKLOG"
