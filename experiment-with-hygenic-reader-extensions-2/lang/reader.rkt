(module reader syntax/module-reader
  racket/base
  #:wrapper1 wrapper1
  (require (for-syntax racket/base))
  (define (wrapper1 thunk)
    (parameterize ([current-readtable (make-dollar-readtable)])
      (thunk)))
  (define (make-dollar-readtable [orig-rt (current-readtable)])
    (make-readtable orig-rt
                    #\$ 'terminating-macro read-dollar))
  (define-syntax (define-reader stx)
    (syntax-case stx ()
      [(_ NAME BODY ...)
       (with-syntax ([GENSYM (datum->syntax stx (gensym))])
         #'(begin
             (define-syntax (GENSYM stx)
               (syntax-case stx ()
                 [(_ in src line col pos) BODY ...]))
             ;(provide GENSYM) ; don't have to provide GENSYM
             (define NAME
               (case-lambda
                 [(ch in)
                  (datum->syntax #f `(,#'GENSYM ,in #f #f #f #f))]
                 [(ch in src line col pos)
                  (datum->syntax #f `(,#'GENSYM ,in ,src ,line ,col ,pos))]))))]))
  (define-reader read-dollar
    #'(lambda (x) x))
  )