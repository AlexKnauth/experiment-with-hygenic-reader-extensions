#lang experiment-with-hygenic-reader-extensions-2
(require (only-in "lang/reader.rkt")
         (for-syntax racket/base
                     (only-in "lang/reader.rkt")
                     (for-syntax racket/base racket/syntax)))
(car '$)
(let ([lambda "whatever"])
  $)
(begin-for-syntax
  (displayln (car '$))
  (define-syntax (shift-phase-level stx)
    (syntax-case stx ()
      [(shift-phase-level stx-expr shift)
       (syntax-shift-phase-level #'stx-expr (syntax-local-eval #'shift))]))
  (displayln (shift-phase-level $ 1))
  )
