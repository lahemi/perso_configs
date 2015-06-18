# You can go up(towards /) by just typing bb dirname.
# eg. [/home/user/dir1/subdir2]$ bb home -> [/home]$
# Source or add this in your shell's rc.
# This should work with Bash too.

bb() {
    # No args == cd
    cd $(awk -v p=$(pwd) -v a="$1" '
        BEGIN{  
            if(p ~ a) {
                i=index(p,a);
                e=length(a);
                print(substr(p,1,(i+e-1)));
            } else { print p }
        }')     
}
