#lang racket

(define (plus x y) (+ x y))

;(plus 2 3)

; UNCURRY
; with explicit params
(define (plus-uncurry x y) (+ x y))

;(plus-uncurry 1 2)

; as lambda function
(define plus-uncurry-lambda
  (λ (x y) (+ x y)))

;(plus-uncurry-lambda 1 2)

; CURRY WITH ONE PARAM
; with one explicit param
(define (plus-curry x)
  (λ (y)
    (+ x y))) ; Ce intoarce functia plus-curry?


;((plus-curry 1) 2)
;(plus-curry 1)
;(plus-curry 1 2)

; as lambda function
(define plus-curry-lambda
  (λ (x)
    (λ (y)
      (+ x y))))

;((plus-curry-lambda 1) 2)
;(plus-curry-lambda 1)


(define inc-curry (plus-curry 1))
;(inc-curry 8) ; <=> ((plus-curry 1) 8)


; TRANSFORM CURRY -> UNCURRY
(define (curry->uncurry f)
  (λ (x y) ((f x) y)))



; TRANSFORM UNCURRY -> CURRY

(define (uncurry->curry f)
  (λ (x)
    (λ (y) (f x y))))


;((curry->uncurry plus-curry) 2 3)
;(((uncurry->curry plus-uncurry) 2) 3)

; FUNCTIONALE
(define L (list 1 2 3 4 5 6))

; map
;(map inc-curry L)
;(map (plus-curry 1) L)
;(map list L)
;(map plus-curry L)
;
;(map list '(1 2 4) '(4 5 6))
;(map list L L)
;(map plus-uncurry L L)
;(map + L L)

; filter
;(filter odd? L)
;(filter (λ (x) (> x 2)) L)

(define (greather-than x)
  (λ (y) (> y x)))
;(filter (greather-than 2) L)

; foldl
(define (my-map-foldl f L)
  (reverse
   (foldl (λ (x acc) (cons (f x) acc))
         null
         L)))

;(my-map-foldl inc-curry L)

; foldr
(define (my-map-foldr f L)
  (foldr (λ (x acc) (cons (f x) acc))
         null
         L))

;(my-map-foldr inc-curry L)


; transpose

(define L1 '(1 2 3))
(define L2 '(4 5 6))
(define L3 '(7 8 9))

;(map list L1 L2 L3)

(define LL '((1 2 3) (4 5 6) (7 8 9)))
(define (transpose LL) (apply map list LL))
;(transpose LL)

; apply map list '((1 2) (3 4))
; map list '(1 2) '(3 4)

;(apply + '(1 2 3))
; + 1 2 3


