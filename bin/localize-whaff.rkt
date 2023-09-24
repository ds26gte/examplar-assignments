#!/usr/bin/env racket

; last modified 2023-09-13

#lang racket

(define (localize-whaff-file ifile ofile)
  (call-with-input-file ifile
    (lambda (i)
      (call-with-output-file ofile
        (lambda (o)
          (let loop ()
            (let ([ln (read-line i)])
              (unless (eof-object? ln)
                (unless (regexp-match "^ *(import|include) +(cpo|lists) *$" ln)
                  (display ln o) (newline o))
                (loop)))))
        #:exists 'replace))))

(let ([args (current-command-line-arguments)])
  (localize-whaff-file
    (vector-ref args 0)
    (vector-ref args 1)))
