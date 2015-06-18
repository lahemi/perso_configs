# Keep a list of visited directories.
PATHHIST=()
cd() {
    builtin cd "$@" 

    # Keeping the limit of how many to remember quite small.
    [[ ${#PATHHIST[@]} -gt 20 ]] && PATHHIST=()
    PATHHIST+=("$PWD")
}

# Given a num, show only that-th dirname.
lsdirs() {
    case "$1" in 
        +([0-9])) print "${PATHHIST[$1]}";;
        *) for p in "${PATHHIST[@]}"; do
               print "$p"
           done;;  
    esac    
}
