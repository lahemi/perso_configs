# b [count] instead of cd ../../../ ....
b() {
    test $# -eq 0 && cd ..
    t=$(print $1|awk '$0 ~ /^[0-9]+$/') #echo|printf for portability
    test -z "$t" && return 0    # return if arg not an integer 
    str=""  
    integer count=0 
    test $# -gt 0 && \
        while test "$count" -lt "$1"; do
            str="$str../"
            let "count = count + 1"
        done    
        cd "$str"
}
