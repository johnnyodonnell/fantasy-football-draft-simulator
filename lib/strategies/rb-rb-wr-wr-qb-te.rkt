#lang racket

(provide rb-rb-wr-wr-qb-te)


(define is-available
  (lambda (roster position)
    (> (send roster get-open-slot-count position) 0)))

(define rb-rb-wr-wr-qb-te
  (lambda (available-players roster)
    (cond
      [(is-available roster 'rb) (send available-players get-top 'rb)]
      [(is-available roster 'wr) (send available-players get-top 'wr)]
      [(is-available roster 'qb) (send available-players get-top 'qb)]
      [else (send available-players get-top 'te)])))

