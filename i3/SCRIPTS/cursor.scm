#! /usr/bin/guile \
-e main -s
!#
; Small wrapper script for xdotool. Combined with some keybindings
; of your window manager, you can move the mouse pointer with your
; keyboard and use left, right and middle click.
; See the Notice of Goodwill for licensing.
; NOG, 2013, Lauri Peltomäki

(use-modules (ice-9 popen) (ice-9 rdelim))

(define move-mouse-pointer
  (lambda (x y)
    (letrec* ((get-loc (lambda (var)
               (let* ((ret "")      
                      (port
                        (open-input-pipe ; Redirection because of debug flags.
                          "xdotool getmouselocation --shell 2>/dev/null")))
                 (do ((line (read-line port) (read-line port)))
                   ((eof-object? line))
                   (cond ((string-contains line var)
                          (set! ret (substring line 2)))))
                 (close-pipe port)
                 (string->number ret))))
       (xloc (get-loc "X"))
       (yloc (get-loc "Y"))
       (xret (number->string (+ x xloc)))
       (yret (number->string (+ y yloc))))
      (system (string-append "xdotool mousemove "xret" "yret)))))

(define main
  (lambda (args)
    (let ((farg (cadr args)))
      (cond ((string=? "h" farg)
             (move-mouse-pointer -20 0))
            ((string=? "j" farg)
             (move-mouse-pointer 0 20))
            ((string=? "k" farg)
             (move-mouse-pointer 0 -20))
            ((string=? "l" farg)
             (move-mouse-pointer 20 0))
            ((string=? "f" farg)
             (system "xdotool click 1"))
            ((string=? "m" farg)
             (system "xdotool click 2"))    ; Middle click
            ((string=? "s" farg)
             (system "xdotool click 3"))
            (#t
             (write "Usage: $0 <h|j|k|l|f|m|s>")
             (newline))))))
