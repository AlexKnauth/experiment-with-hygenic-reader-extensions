#lang experiment-with-hygenic-reader-extensions-2
(require (only-in "lang/reader.rkt"))
(car '$)
(let ([lambda "whatever"])
  $)