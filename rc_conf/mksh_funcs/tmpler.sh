#!/usr/bin/mksh
# Create a quick testing file for lua and shells.
# GPLv3, 2013, Lauri Peltomäki

letters=(a b c d e f g h i j k l m n o p r s t u v w x y z)

tmpler() {
    [[ $# != 1 ]] && return 0
    [[ "$1" != @(lua|*(mk|z|*(b|d)a)sh) ]] && return 0

    for l in "${letters[@]}"; do
        [[ "$1" = *sh ]] && f="${l}.sh" || f="${l}.$1"
        [[ ! -e "$f" ]] && {
            touch "$f"
            print "$f"
            chmod 700 "$f"
            print "#!/usr/bin/env ${1}\n" > "$f"
        } && break
    done
}

