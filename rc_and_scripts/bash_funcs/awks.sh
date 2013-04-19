#!/usr/bin/env bash
# Beautiful wonders of awk.
# These work at least with GNU awk 4.0.2.
# Provided 'as-is', with no warranty.

# Overly elaborate listing, with item numbering.
function awkln() {
    ls -goh|awk 'BEGIN{l=0;}
                 {if(l>99) { 
                     if(l<10)
                         print l++ "   " $0;
                     else print l++ "  " $0}
                 else {
                     if(l<10)
                         print l++ "  " $0;
                     else
                         print l++ " " $0}}'
}

# Creates a treeview recursively out of the
# direcories under current working directory.
function awktree() {
    ls -RF|awk '/:$/ {gsub(/:$/, "");
                      gsub(/[^-][^\/]*\//, "--");
                      sub(/-/, "|");
                      print}'
}
