#! /usr/bin/guile -s
!#

(use-modules (ice-9 popen) (ice-9 rdelim))

(define xkbtoggle
  (lambda ()
    (let* ((layout "")
           (port (open-input-pipe "setxkbmap -query")))
      (do ((line (read-line port) (read-line port)))
        ((eof-object? line))
        (cond ((string-contains line "layout")
               (set! layout (substring line (- (string-length line) 2))))))
      (close-pipe port)
      (cond ((string=? layout "fi")
             (system "setxkbmap us -variant colemak \
                     && xmodmap -e 'keycode 66 = Return'"))
            ((string=? layout "us")
             (system "setxkbmap fi \
                     && xmodmap -e 'clear Lock' \
                     -e 'keycode 66 = Return'"))))))

(xkbtoggle)
