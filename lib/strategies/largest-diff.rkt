#lang racket

(require "../positions.rkt")

(provide largest-diff)


(define largest-diff
  (lambda (available-players roster)
    (car
      (foldl
        (lambda (position largest-diff-pair)
          (let ([open-slots (send roster get-open-slot-count position)])
            (if (> open-slots 0)
                (let* ([largest-diff (cadr largest-diff-pair)]
                       [top-player (send available-players get-top position)]
                       [bottom-player
                         (send available-players
                               get-bottom position (sub1 open-slots))]
                       [current-diff
                         (- (send top-player get-total-points)
                            (send bottom-player get-total-points))])
                  (if (or (not largest-diff)
                          (> current-diff largest-diff))
                      (list top-player current-diff)
                      largest-diff-pair))
                largest-diff-pair)))
        (list #f #f)
        positions))))

