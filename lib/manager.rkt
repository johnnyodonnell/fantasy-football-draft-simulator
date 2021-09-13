#lang racket

(require "./roster.rkt")

(provide manager%)


(define manager%
  (class* object%
          ()
          (super-new)
          (init-field num)
          (init-field strategy)
          (field [roster (make-object roster%)])
          (define/public get-name
                         (lambda ()
                           (string-append
                             "Manager "
                             (number->string num))))
          (define/public make-selection
                         (lambda (available-players)
                           (strategy available-players roster)))
          (define/public (get-roster) roster)))

