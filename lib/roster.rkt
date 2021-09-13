#lang racket

(require "./positions.rkt")

(provide roster%)
(provide total-slots)


(define slot-limits
  (hash 'qb 1
        'rb 2
        'wr 2
        'te 1))

(define total-slots
  (foldl
    (lambda (position sum)
      (+ sum (hash-ref slot-limits position)))
    0
    positions))

(define next-open-slot-index
  (lambda (slots [i 0])
    (cond
      [(>= i (vector-length slots)) i]
      [(vector-ref slots i) (next-open-slot-index slots (add1 i))]
      [else i])))

(define roster%
  (class* object%
          ()
          (super-new)
          (field [player-map
                   (hash 'qb (make-vector (hash-ref slot-limits 'qb) #f)
                         'rb (make-vector (hash-ref slot-limits 'rb) #f)
                         'wr (make-vector (hash-ref slot-limits 'wr) #f)
                         'te (make-vector (hash-ref slot-limits 'te) #f))])
          (define/public get-open-slot-count
                         (lambda (position)
                           (- (hash-ref slot-limits position)
                              (next-open-slot-index
                                (hash-ref player-map position)))))
          (define/public add-player
                         (lambda (player)
                           (let* ([position (send player get-position)]
                                  [slots
                                    (hash-ref player-map position)]
                                  [next-index (next-open-slot-index slots)])
                             (if (< next-index
                                    (hash-ref slot-limits position))
                                 (begin
                                   (vector-set! slots next-index player)
                                   #t)
                                 #f))))
          (define/public get-total-projected-score
                         (lambda ()
                           (foldl
                             (lambda (position sum)
                               (+ sum
                                  (foldl
                                    (lambda (player sum)
                                      (+ sum (send player get-total-points)))
                                    0
                                    (vector->list
                                      (hash-ref player-map position)))))
                             0
                             positions)))
          (define/public print
                         (lambda ()
                           (for ([position positions])
                                (for ([player (hash-ref player-map position)])
                                     (if player
                                         (displayln
                                           (string-append
                                             (send player get-name)
                                             " ("
                                             (number->string
                                               (send player get-total-points))
                                             ")"))
                                         #f)))))))


