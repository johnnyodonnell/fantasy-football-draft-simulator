#lang racket

(require "./lib/manager.rkt")
(require "./lib/roster.rkt")
(require "./lib/players.rkt")
(require "./lib/strategies/highest-scorer.rkt")


(define num-of-managers 10)

(define create-managers
  (lambda ()
    (build-vector
      num-of-managers
      (lambda (i)
        (make-object manager% (add1 i) highest-scorer)))))

(define by-roster-score
  (lambda (manager1 manager2)
    (< (send (send manager1 get-roster) get-total-projected-score)
       (send (send manager2 get-roster) get-total-projected-score))))

(define run
  (lambda ()
    (let ([managers (create-managers)])
      (for ([i (in-range total-slots)])
           (for ([manager
                   (if (even? i)
                       managers
                       (reverse
                         (vector->list managers)))])
                (let ([selected-player
                        (send manager make-selection players)])
                  (send players remove selected-player)
                  (send
                    (send manager get-roster) add-player selected-player))))
      (for ([manager (sort (vector->list managers) by-roster-score)])
           (let ([roster (send manager get-roster)])
             (displayln (string-append "---" (send manager get-name) "---"))
             (displayln
               (string-append
                 "Roster score: "
                 (number->string (send roster get-total-projected-score))))
             (send roster print)
             (displayln "--------------------"))))))

(run)

