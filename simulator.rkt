#lang racket

(require "./lib/manager.rkt")
(require "./lib/roster.rkt")
(require "./lib/players.rkt")
(require "./lib/strategies/highest-scorer.rkt")
(require "./lib/strategies/rb-rb-wr-wr-qb-te.rkt")
(require "./lib/strategies/rb-rb-wr-wr-te-qb.rkt")
(require "./lib/strategies/largest-diff.rkt")


(define num-of-managers 10)

(define create-managers
  (lambda ()
    (list
      (make-object manager% 1 largest-diff)
      (make-object manager% 2 largest-diff)
      (make-object manager% 3 largest-diff)
      (make-object manager% 4 largest-diff)
      (make-object manager% 5 largest-diff)
      (make-object manager% 6 largest-diff)
      (make-object manager% 7 largest-diff)
      (make-object manager% 8 largest-diff)
      (make-object manager% 9 largest-diff)
      (make-object manager% 10 largest-diff))))

(define by-roster-score
  (lambda (manager1 manager2)
    (>= (send (send manager1 get-roster) get-total-projected-score)
        (send (send manager2 get-roster) get-total-projected-score))))

(define run
  (lambda ()
    (let ([managers (create-managers)])
      (for ([i (in-range total-slots)])
           (for ([manager
                   (if (even? i)
                       managers
                       (reverse managers))])
                (let ([selected-player
                        (send manager make-selection players)])
                  (send players remove selected-player)
                  (send
                    (send manager get-roster) add-player selected-player))))
      (for ([manager (sort managers by-roster-score)])
           (let ([roster (send manager get-roster)])
             (displayln
               (string-append
                 "---- "
                 (send manager get-name)
                 " ----"))
             (displayln
               (string-append
                 "Roster score: "
                 (number->string (send roster get-total-projected-score))))
             (send roster print)
             (displayln "--------------------"))))))

(run)

