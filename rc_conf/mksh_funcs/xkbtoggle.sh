xkbtoggle() {
    layout=$(setxkbmap -query|awk '/layout/ {print $2}')
    variant=$(setxkbmap -query|awk '/variant/ {print $2}')
    test "$layout" = "fi" \
        && setxkbmap us -variant colemak \
        && xmodmap -e 'keycode 66 = Return'
    test "$layout" = "us" \
        && setxkbmap us -variant colemak \
        && xmodmap -e 'keycode 66 = Return'
    test "$variant" = "colemak" \
        && setxkbmap fi \
        && xmodmap -e 'clear Lock' -e 'keycode 66 = Return'
}
