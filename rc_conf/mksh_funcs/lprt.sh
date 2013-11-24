# A little helper for grabbing a small portion of a text file,
# makes pasting snippets around easier on commandline.
# Place !LABEL and nothing else in a line just before the part
# you want to print and then supply as $2 how many lines to print.
lprt() {
    [ $# != 2 ] && return 0
    [ ! -f "$1" ] && return 0
    [ -z $(print "$2"|awk '$0~/^[0-9]+$/') ] && return 0 # Test $2 is integer.

    file="$1"
    en="$2" # if $2==0 then print till the EOF.

    awk -v en="$en" '{
        if($0~/^!LABEL/) { sn=NR; }
        if(sn) {
            if(en==0) { if(NR>sn) { print; } }
            else if(NR>sn && NR<(sn+en)) { print; } }
    }' "$file"

    # Cleaning up, be neat.
    sed -i 's/^!LABEL//' "$file"
}
