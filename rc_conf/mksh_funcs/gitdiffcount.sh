function gitdiffcount() {
    [ $# -ne 2 ] && echo "Give two branches to compare." && return 1
    git --no-pager diff "$1".."$2" | awk \ 
        '       
    /^\+/ { insertions++ }
    /^-/  { deletions++ } 
    END {   
        print "insertions: " insertions
        print "deletions: " deletions
    }'
}
