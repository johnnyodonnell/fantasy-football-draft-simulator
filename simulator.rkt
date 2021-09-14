#lang racket

(require "./lib/manager.rkt")
(require "./lib/roster.rkt")
(require "./lib/players.rkt")
(require "./lib/strategies/highest-scorer.rkt")
(require "./lib/strategies/rb-rb-wr-wr-qb-te.rkt")
(require "./lib/strategies/rb-rb-wr-wr-te-qb.rkt")


(define num-of-managers 10)

(define create-managers
  (lambda ()
    (list
      (make-object manager% 1 rb-rb-wr-wr-qb-te)
      (make-object manager% 2 rb-rb-wr-wr-qb-te)
      (make-object manager% 3 rb-rb-wr-wr-qb-te)
      (make-object manager% 4 rb-rb-wr-wr-qb-te)
      (make-object manager% 5 rb-rb-wr-wr-qb-te)
      (make-object manager% 6 rb-rb-wr-wr-qb-te)
      (make-object manager% 7 rb-rb-wr-wr-qb-te)
      (make-object manager% 8 rb-rb-wr-wr-te-qb)
      (make-object manager% 9 rb-rb-wr-wr-qb-te)
      (make-object manager% 10 rb-rb-wr-wr-qb-te))))

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

