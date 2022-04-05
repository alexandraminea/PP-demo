#lang racket

(require (lib "trace.ss"))

; intarziere cu inchidere functionala
(define sum
  (λ (x y)
    (λ () (+ x y)))) ; inchidere functionala
;(sum 1 2)            ; rezultatul este o inchidere functionala
;((sum 1 2))          ; fortarea rezultatului

; intarziere cu promisiuni
(define sum2
  (λ (x y)
    (delay (+ x y)))) ; promisiune
;(sum2 1 2)            ; rezultatul este o promisiune
;(force (sum2 1 2))    ; fortarea rezultatului



; fluxuri
(define ones-stream
  (cons 1 (λ () ones-stream)))
;ones-stream                    ; (1 1 1 ...)

(define ones-stream-2
  (stream-cons 1 ones-stream-2))


;; functie care ia primele n elemente dintr-un sir
(define (stream-take s n)
  (cond ((zero? n) '())
        ((stream-empty? s) '())
        (else (cons (stream-first s)
                    (stream-take (stream-rest s) (- n 1))))))



;(stream-take ones-stream-2 5)


; generator pentru numere naturale
(define (make-naturals k)
  (stream-cons k (make-naturals (add1 k))))

(define naturals-stream (make-naturals 0))

;(trace stream-take)

;(stream-take naturals-stream 5)


;(stream-first (stream-rest naturals-stream))


; adunarea a doua stream-uri
(define add
  (lambda (s1 s2)  
    (stream-cons (+ (stream-first s1) (stream-first s2))
                 (add (stream-rest s1) (stream-rest s2)))))

;(stream-take (add ones-stream-2 ones-stream-2) 10)

; fibo
(define fibo-stream
  (stream-cons 0
     (stream-cons 1
        (add fibo-stream (stream-rest fibo-stream)))))


;(stream-take fibo-stream 10)


; fluxuri produse cu map

(define doubles
  (stream-cons 1 (stream-map (λ (x) (* x 2)) doubles)))

;(stream-take doubles 10)

; fluxuri produse cu stream-zip-with

