#!/usr/bin/guile -s
!#
;; Rough decimal to hexadecimal converter,
;; designed to work with Unicode encoding conversions.
;;
;; 16^3 = 4096
;; 16^2 = 256

;; Helper procedure, allows modulo to work with non-integers.
;; Plus, it feels good to use your own procedures.
(define (precision-mod dividend divisor)
  (* divisor (- (/ dividend divisor)
                (floor (/ dividend divisor)))))

;; Smallest number, from right to left.
(define (first-level dividend)
  (inexact->exact
    (floor
      (precision-mod
        (precision-mod
          (precision-mod dividend 4096) 256) 16))))

(define (second-level dividend)
  (inexact->exact
    (floor
      (/ (precision-mod
           (precision-mod dividend 4096) 256) 16))))
         

(define (third-level dividend)
  (inexact->exact
    (floor
      (/ (precision-mod dividend 4096) 256))))

(define (fourth-level dividend)
  (inexact->exact
    (floor (/ dividend 4096))))

;; 0-9 a-f, radix 16, hexadecimal style.
;; Better to redefine a-f accordingly,
;; or just be lame and do strings?
(define (radix-converter result)
  (cond ((= result 10) "a")
        ((= result 11) "b")
        ((= result 12) "c")
        ((= result 13) "d")
        ((= result 14) "e")
        ((= result 15) "f")
        (else (number->string result))))

;; Bringing it all together, concatenating some hexes.
(define (hex-appender div)
  (string-append (radix-converter (fourth-level div))
                 (radix-converter (third-level div))
                 (radix-converter (second-level div))
                 (radix-converter (first-level div))))

(define (main arg)
  (display (cond ((string? arg) (hex-appender (string->number arg)))
                 ((number? arg) (hex-appender arg))))
  (newline))

