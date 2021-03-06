#!/usr/bin/mksh
# This is a small utility that can be used to check words from the dictionary.
# I'm using the Merriam-Webster English dictionary, as plain text files.
# Source: http://www.mso.anu.edu.au/~ralph/OPTED/index.html
# See the Notice of Goodwill for more information about licensing.
# NOG, 2013, Lauri Peltomäki

# Adjust the path accordingly.
thepath="$HOME/Dissection_Table/THESAURUS/proc_webster"

hatch_vars() {
    fl=$(printf "$1"|awk '{printf(tolower(substr($0,1,1)))}')
    fh=$(printf "$1"|awk '{printf(toupper(substr($0,1,1)))}')
    rest=$(printf "$1"|awk '{printf(tolower(substr($0,2)))}')
    file="$thepath"/webster_"$fl".txt
}

# $0 -s <word> will use less greedy search for the word.
if test $# -gt 1; then    
    if test "$1" != "-s"; then
        exit 0  # We "fail" silently if there's too many arguments.
    else
        shift
        hatch_vars "$1"
        awk '/^['"$fl$fh"']'"$rest"' \(/ {print}' "$file"
    fi
else
    hatch_vars "$1"
    awk '/^['"$fl$fh"']'"$rest"'/ {print}' "$file"
fi
