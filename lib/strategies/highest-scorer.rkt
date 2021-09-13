#lang racket

(require "../positions.rkt")

(provide highest-scorer)


(define highest-scorer
  (lambda (available-players roster)
    (foldl
      (lambda (position highest-scorer)
        (if (> (send roster get-open-slot-count position) 0)
            (let ([current-player (send available-players get-top position)])
              (if (or (not highest-scorer)
                      (> (send current-player get-total-points)
                         (send highest-scorer get-total-points)))
                  current-player
                  highest-scorer))
            highest-scorer))
      #f
      positions)))


