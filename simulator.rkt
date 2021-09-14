#lang racket

(require "./lib/manager.rkt")
(require "./lib/roster.rkt")
(require "./lib/players.rkt")
(require "./lib/strategies/highest-scorer.rkt")
(require "./lib/strategies/rb-rb-wr-wr-qb-te.rkt")
(require "./lib/strategies/rb-rb-wr-wr-te-qb.rkt")
(require "./lib/strategies/largest-diff.rkt")
(require "./lib/strategies/furthest-from-avg.rkt")
(require "./lib/strategies/user-input.rkt")


(define num-of-managers 10)

(define create-managers
  (lambda ()
    (list
      (make-object manager% 1 user-input)
      (make-object manager% 2 furthest-from-avg)
      (make-object manager% 3 furthest-from-avg)
      (make-object manager% 4 furthest-from-avg)
      (make-object manager% 5 furthest-from-avg)
      (make-object manager% 6 furthest-from-avg)
      (make-object manager% 7 furthest-from-avg)
      (make-object manager% 8 furthest-from-avg)
      (make-object manager% 9 furthest-from-avg)
      (make-object manager% 10 furthest-from-avg))))

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
                  (displayln
                    (string-append
                      (send manager get-name)
                      " selected "
                      (string-upcase
                        (symbol->string
                          (send selected-player get-position)))
                      " "
                      (send selected-player get-name)))
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

