tlines() {
    awk '!/^$/{t++}END{print t}' $(find .|grep -E "$1")
}
