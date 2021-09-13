#lang racket

(provide player%)


(define player%
  (class* object%
          ()
          (super-new)
          (init-field name)
          (init-field position)
          (init-field total-points)
          (define/public (get-name) name)
          (define/public (get-position)
                         (string->symbol (string-downcase position)))
          (define/public (get-total-points) (string->number total-points))))


