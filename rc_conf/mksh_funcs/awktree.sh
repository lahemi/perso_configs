#!/usr/bin/mksh

# Create a tree view of the directories under PWD.
awktree() {
    ls -RF|awk '/:$/ {gsub(/:$/,"");
                      gsub(/[^-\/]*\//,"--");
                      sub(/-/,"|");
                      print; }'
}

