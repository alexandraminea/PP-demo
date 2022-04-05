#lang racket

(require (lib "trace.ss"))

; FACTORIAL PE STIVA
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (- n 1)))))

;(trace factorial)
(factorial 5)


; FACTORIAL PE COADA
(define (fact-helper n acc)
  (if (zero? n) acc
      (fact-helper (- n 1) (* acc n))))

(define (fact-tail n) (fact-helper n 1))

;(trace fact-helper)
(fact-tail 5)


; FIBO PE STIVA
(define (fibo-stack n)
 (cond ((<= n 1) n) 
       (else (+ (fibo-stack (- n 1)) (fibo-stack (- n 2))))))


; SUMLIST STIVA
(define (sum-stack L)
  (if (null? L) 0
      (+ (car L) (sum-stack (cdr L)))))

(sum-stack '(1 2 3 4))

; SUMLIST COADA

(define (sum-helper L acc)
  (if (null? L) acc
      (sum-helper (cdr L) (+ (car L) acc))))

(define (sum-tail L)
  (sum-helper L 0))


;(fibo-stack 30)

; FIBO PE COADA
(define (fibo-helper n a b)
  (if (zero? n)
      a
      (fibo-helper (- n 1) b (+ a b))))

(define (fibo-tail n)
  (fibo-helper n 0 1))

;(fibo-tail 30)

; APPEND PE STIVA
(define (append-stack A B)
  (if (null? A)
      B
      (cons (car A) (append-stack (cdr A) B))))

(append-stack '(1 2 3) '(4 5 6))

; APPEND PE COADA
(define (append-helper A B)
  (if (null? B)
      (reverse A)
      (append-helper (cons (car B) A) (cdr B))))

(define (append-tail A B)
  (append-helper (reverse A) B))

(append-tail '(1 2 3) '(4 5 6))


; SELECT PE STIVA

(define (less-than-five n)
  (if (< n 5) #t #f))

(define (select f L)
  (if (null? L) '()
      (if (f (car L))
      (cons (car L) (select f (cdr L)))
      (select f (cdr L)))))

(select less-than-five '(1 3 5 9 2 5))


; SELECT PE COADA
(define (select-helper f L Result)
  (if (null? L) (reverse Result)
      (if (f (car L))
             (select-helper f (cdr L) (cons (car L) Result))
             (select-helper f (cdr L) Result))))

(define (select-tail f L) (select-helper f L '()))


(select-tail less-than-five '(1 3 5 9 2 5))


; MEMBER
(member 2 '(1 2 3))
(member 2 '(1 3 4))

(define (f n acc)
  (if (= n 0)
      acc
      (+ 1 (f (- n 1) (+ acc 1)))))

(f 4 0)
