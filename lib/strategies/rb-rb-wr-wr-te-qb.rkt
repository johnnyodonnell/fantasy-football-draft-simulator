#lang racket

(provide rb-rb-wr-wr-te-qb)


(define is-available
  (lambda (roster position)
    (> (send roster get-open-slot-count position) 0)))

(define rb-rb-wr-wr-te-qb
  (lambda (available-players roster)
    (cond
      [(is-available roster 'rb) (send available-players get-top 'rb)]
      [(is-available roster 'wr) (send available-players get-top 'wr)]
      [(is-available roster 'te) (send available-players get-top 'te)]
      [(is-available roster 'qb) (send available-players get-top 'qb)]
      [(is-available roster 'k) (send available-players get-top 'k)]
      [else (send available-players get-top 'dst)])))

