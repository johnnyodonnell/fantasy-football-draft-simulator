#lang racket

(require "../positions.rkt")

(provide user-input)


(define get-user-input
  (lambda (available-players roster)
    (displayln "Select player by entering their position:")
    (let ([input
            (string->symbol
              (string-downcase
                (read-line (current-input-port) 'any)))])
      (if (> (send roster get-open-slot-count input) 0)
          (send available-players get-top input)
          (begin
            (displayln "Invalid input, please try again...")
            (get-user-input available-players roster))))))

(define user-input
  (lambda (available-players roster)
    (displayln " ")
    (displayln "--- User Selection ---")
    (displayln "Current roster:")
    (send roster print)
    (displayln " ")
    (displayln "Top players for each open position:")
    (for-each
      (lambda (position)
        (let ([open-slots (send roster get-open-slot-count position)])
          (if (> open-slots 0)
              (let ([top-player (send available-players get-top position)])
                (displayln
                  (string-append
                    (string-upcase
                      (symbol->string position))
                    " "
                    (send top-player get-name)
                    " ("
                    (number->string
                      (send top-player get-total-points))
                    ")")))
                #f)))
      positions)
    (displayln " ")
    (let ([selected-player (get-user-input available-players roster)])
      (displayln "----------------------")
      (displayln " ")
      selected-player)))

