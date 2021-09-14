#lang racket

(require "../positions.rkt")

(provide furthest-from-avg)


(define furthest-from-avg
  (lambda (available-players roster)
    (car
      (foldl
        (lambda (position furthest-from-avg-pair)
          (let ([open-slots (send roster get-open-slot-count position)])
            (if (> open-slots 0)
                (let* ([furthest-from-avg (cadr furthest-from-avg-pair)]
                       [top-player (send available-players get-top position)]
                       [avg (send available-players get-avg position)]
                       [current-distance
                         (- (send top-player get-total-points) avg)])
                  (if (or (not furthest-from-avg)
                          (> current-distance furthest-from-avg))
                      (list top-player current-distance)
                      furthest-from-avg-pair))
                furthest-from-avg-pair)))
        (list #f #f)
        positions))))

