#lang racket

(require csv-reading)

(require "./player.rkt")

(provide players)


(define remove-from-list remove)

(define filter-by-position
  (lambda (position players-list)
    (filter
      (lambda (player)
        (equal? position (send player get-position)))
      players-list)))

(define create-all-players-list
  (lambda ()
    (map
      (lambda (row)
        (make-object player%
                     (string-trim (car row))
                     (string-trim (cadr row))
                     (string-trim (caddr row))))
      (csv->list
        (make-csv-reader
          (open-input-file "./data/2020-player-data.csv")
          '((separator-chars #\,)
            (strip-leading-whitespace? . #t)
            (strip-trailing-whitespace? . #t)))))))

(define players%
  (class* object%
          ()
          (super-new)
          (field [player-map
                   (let ([all-players-list (create-all-players-list)])
                     (make-hash
                       (list
                         (cons 'qb
                               (filter-by-position 'qb all-players-list))
                         (cons 'rb
                               (filter-by-position 'rb all-players-list))
                         (cons 'wr
                               (filter-by-position 'wr all-players-list))
                         (cons 'te
                               (filter-by-position 'te all-players-list)))))])
          (define/public get-top
                         (lambda (position)
                           (let ([players (hash-ref player-map position)])
                             (if (empty? players)
                                 #f
                                 (car players)))))
          (define/public remove
                         (lambda (player)
                           (let ([position (send player get-position)])
                             (hash-set!
                               player-map
                               position
                               (remove-from-list
                                 player
                                 (hash-ref player-map position))))))))

(define players (make-object players%))

