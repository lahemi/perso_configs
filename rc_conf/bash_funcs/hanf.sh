#!/usr/bin/env bash
# A small and sluggish utility that allows
# writing Korean in the commandline.
# On positive note, it uses only a recent(4.2)
# version of GNU bash, and v.4 of GNU awk.
# Provided 'as-is', with no warranty.
# GPLv2, Lauri Peltomäki <lahemi.maki@gmail.com>


# Associative arrays, holding the conversion values.
declare -A far=([r]=0 [R]=1 [s]=2 [e]=3 [E]=4 [f]=5 [a]=6 [q]=7 \
                [Q]=8 [t]=9 [T]=10 [d]=11 [w]=12 [W]=13 [c]=14 \
                [z]=15 [x]=16 [v]=17 [g]=18)
declare -A sar=([k]=0 [o]=1 [i]=2 [O]=3 [j]=4 [p]=5 [u]=6 [P]=7 \
                [h]=8 [hk]=9 [ho]=10 [hl]=11 [y]=12 [n]=13 [nj]=14 \
                [np]=15 [nl]=16 [b]=17 [m]=18 [ml]=19 [l]=20)
declare -A tar=([r]=1 [R]=2 [rt]=3 [s]=4 [st]=5 [sg]=6 [e]=7 [f]=8 \
                [fr]=9 [fa]=10 [fq]=11 [ft]=12 [fx]=13 [fv]=14 \
                [fg]=15 [a]=16 [q]=17 [qt]=18 [t]=19 [T]=20 [d]=21 \
                [w]=22 [c]=23 [z]=24 [x]=25 [v]=26 [g]=27)

function converter() {

    str="$1"

    # We need to divide arg in smaller pieces in order to make the conversions
    # on fly. This is an inefficient method, as everything needs to be converted
    # and computed separately, especially as we're using bash+awk.
    intl=$(echo -n "$str"|awk '{ printf substr($1,1,1) }')

    medl=$(echo -n "$str"|awk '{ if(substr($1,2,2) ~/hk|ho|hl|nj|np|nl|ml/)
                                     printf substr($1,2,2)
                                 else
                                     printf substr($1,2,1) }')
    # Looks horrible, put it's necessary to test multiletter patterns for this to work.
    finl=$(echo -n "$str"|awk '{ if(substr($1,2,2) ~/hk|ho|hl|nj|np|nl|ml/) {
                                     if(substr($1,4,2) ~/st|sg|fr|fa|fq|ft|fx|fv|fg|qt/)
                                         printf substr($1,4,2)
                                     else
                                         printf substr($1,4,1) }
                                 else {
                                     if(substr($1,3,2) ~/st|sg|fr|fa|fq|ft|fx|fv|fg|qt/)
                                         printf substr($1,3,2)
                                     else
                                         printf substr($1,3,1)} }')

    # Picking the corresponding values out of the arrays and calculating
    # required Unicode values.
    frd="${far[$intl]}"
    srd="${sar[$medl]}"
    if [[ -z "$finl" ]]; then
        trd=0
    else
        trd="${tar[$finl]}"
    fi

    let "han_dec = $frd * 588 + $srd * 28 + $trd + 44032"
    # C functions is bash, huzzah.
    printf "\u$(printf '%x' $han_dec)"
}

function usage() {
    printf "\
Enter syllables separated by whitespace.\n\
You can use \"_\" character to input space\n\
in the output."
    return 1
}

function hanf() {
    if [[ $# == 0 ]]; then
        usage
    else
        # $@ == all given args.
        for i in $@; do
            if [[ "$i" = "_" ]]; then
                printf " "
            else
                converter "$i"
            fi
        done
    fi
    printf "\n"
}


## Testing notes.
#declare -ar farg=('r' 'R' 's' 'e' 'E' 'f' 'a' 'q' 'Q' 't' 'T' 'd' 'w' \
#                    'W' 'c' 'z' 'x' 'v' 'g')
#declare -ar sarg=('k' 'o' 'i' 'O' 'j' 'p' 'u' 'P' 'h' 'hk' 'ho' 'hl' \
#                    'y' 'n' 'nj' 'np' 'nl' 'b' 'm' 'ml' 'l')
#declare -ar targ=('' 'r' 'R' 'rt' 's' 'st' 'sg' 'e' 'f' 'fr' 'fa' 'fq' \
#                    'ft' 'fx' 'fv' 'fg' 'a' 'q' 'qt' 't' 'T' 'd' 'w' \
#                    'c' 'z' 'x' 'v' 'g')
#
# Indexed arrays would've otherwise been nicer, but look at _this_ mess..
#for (( i = 0; i < ${#farg[@]}; i++ )); do
#    if [[ "${farg[$i]}" = "${intl}" ]]; then
#        echo $i;
#    fi
#done
