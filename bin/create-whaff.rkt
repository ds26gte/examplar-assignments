#!/usr/bin/env racket

; last modified 2023-09-13

#lang racket

(define (create-test-file whaff-file)
  (call-with-input-file "test.arr"
    (lambda (i)
      (call-with-output-file "test-w.arr"
        (lambda (o)
          (let ([done? #f])
            (let loop ()
              (let ([ln (read-line i)])
                (unless (eof-object? ln)
                  (unless done?
                    (when (regexp-match "^ *(import|include) +file" ln)
                      (set! ln (regexp-replace "file\\(\".*?\"\\)" ln
                                               (string-append "file(\"" whaff-file "\")")))
                      (set! done? #t)))
                  (unless (regexp-match "^ *(import|include) +(cpo|lists) *$" ln)
                    (display ln o) (newline o))
                  (loop))))))
        #:exists 'replace))))

(let ([args (current-command-line-arguments)])
  (create-test-file
    (vector-ref args 0)))

