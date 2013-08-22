#! /usr/bin/guile \
-e main -s
!#

; TODO read ossmix output line by line, and do
; the magicks in Guile we now do with awk.
; Update: We managed to print the desired data using Guile,
; but couldn't find a way to "return" it from the procedure.

(use-modules (ice-9 popen) (ice-9 rdelim))  ; pipes and read-line

(define device "jack.green.front")
(define mute   "jack.green.mute")

(define awk-vol
  (lambda ()
    (let* ((port (open-input-pipe (string-append
                                    "ossmix -c|awk 'BEGIN{FS=\":\"} /"
                                    device
                                    " / {printf $2}'"))) ;Significant whitespace
           (volume (read-line port)))
      (close-pipe port)
      (string->number volume))))

; Still sort of inefficient, we should stop the loop
; the moment we find the desired line.
(define toggle-mute
  (lambda ()
    (let ((port (open-input-pipe "ossmix -c")))
      (do ((line (read-line port) (read-line port)))
        ((eof-object? line))
        (cond ((string-contains line mute)
               (let ((volume (substring line (- (string-length line) 3))))
                 (cond ((string=? volume "OFF")
                        (system* "ossmix" mute "ON"))
                       (#t (system* "ossmix" mute "OFF")))))))
        (close-pipe port))))

(define set-vol
  (lambda (s)
    (system* "ossmix" device (cond ((number? s) (number->string s))
                                   (#t s)))))

(define increase-vol
  (lambda (vol)
    (let ((setvol (number->string (+ vol (awk-vol)))))
      (system* "ossmix" device setvol))))

(define decrease-vol
  (lambda (vol)
    (let ((setvol (number->string (- (awk-vol) vol))))
      (system* "ossmix" device setvol))))

(define main
  (lambda (args)
    (cond ((string=? "d" (cadr args))
           (decrease-vol (string->number (caddr args))))
          ((string=? "i" (cadr args))
           (increase-vol (string->number (caddr args))))
          ((string=? "s" (cadr args))
           (set-vol (caddr args)))
          ((string=? "c" (cadr args))
           (write (awk-vol)) (newline))
          ((string=? "t" (cadr args))
           (toggle-mute))
          (#t
           (write "Usage: $0 <d|i|s|c|t> [number]")
           (newline)))))

