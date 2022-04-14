
import Data.List

useful_functions = do
    print $ drop 3 [1,2,3,4,5]
    print $ takeWhile (< 3) [1,2,3,4,1,2,3,4]
    print $ dropWhile (< 3) [1,2,3,4,5,1,2,3]
    print $ span (< 3) [1,2,3,4,1,2,3,4]
    print $ break (>= 3) [1,2,3,4,1,2,3,4]
    print $ splitAt 3 [1,2,3,4,5]

------------------------------------------- LIST COMPREHENSIONS ----------------------------------------------

l1 = [ x*2 | x <- [1..10]]
l2 = [ x*y | x <- [2,5,10], y <- [8,10,11]]

nouns       = ["hobo","frog","pope"]  
adjectives  = ["lazy","grouchy","scheming"]
l3          = [adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns]

xxs         = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]
l4          = [ [ x | x <- xs, even x ] | xs <- xxs]


removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]
-- removeNonUppercase "IdontLIKEFROGS"

length' xs = sum [1 | _ <- xs]  

------------------------------------------- INFINITE LISTS ---------------------------------------------------
naturals = [0..]

-- naturals = iter 0
--     where iter x = x : iter (x + 1)

-- repeat
repeat' :: a -> [a]  
repeat' x = x : repeat' x

replicate :: Int -> a -> [a]
replicate n x =  take n (repeat x)

-- iterate
iterate'' :: (a -> a) -> a -> [a]
iterate'' f x = x : iterate'' f (f x)

-- cycle
-- take 20 $ cycle [2, 5, 7]

-- intersperse
onesTwos = intersperse 2 ones -- [1, 2, 1, 2, ..] 

-- lab examples
ones = repeat 1 -- [1, 1, 1, ..] 
fibs = 0 : 1 : zipWith (+) fibs (tail fibs) -- sirul lui Fibonacci 
powsOfTwo = iterate (* 2) 1 -- puterile lui 2
palindromes = filter isPalindrome [0..] -- palindroame
    where  
    isPalindrome x = show x == reverse (show x) -- truc: reprezint numarul ca String

-- ziPwith
l5 = zipWith (+) [0..] [1..]
l6 = zipWith (zipWith (*)) [[1,2,3],[3,5,6],[2,3,4]] [[3,2,2],[3,4,5],[5,4,3]]

-- zipWith3
l7 = zipWith3 (\x y z -> x+2*y+3*z) [1..5][5..10][10..15]

-- let
g1 :: (Ord a, Num a) => [(a, a)] -> [a]
g1 xs = [a | (x, y) <- xs, let a = x * y, a >= 8]

------------------------------------------ FUNCTION APPLICATION ($) ------------------------------------------
-- left vs right associative

{- 
    Normally, when we write f a b c, it is equivalent to ((f a) b) c), beacuse of the curry form
    This means the function application is left-associative
    But we can use also the right-associative form of the function application using ($)
    
    ($) :: (a -> b) -> a -> b  
    f $ x = f x

    So, if we have 'something $ other_thing', then 'something' is the function and 'other_thing' is the argument
-}


right_association = do
    print $ sqrt 4 + 2 + 3
    print $ sqrt (4 + 2 + 3)
    print $ sqrt $ 4 + 2 + 3
    print $ sum (filter (> 10) (map (*2) [2..10]))
    print $ sum $ filter (> 10) $ map (*2) [2..10]
    print $ map ($ 3) [(4+), (10*), (^2), sqrt]
    print $ map (*3) [1, 2, 3]
    -- print $ map $ (*3) [1, 2, 3]

------------------------------------------ FUNCTION COMPOSITION (.) ------------------------------------------
{-
    In maths, function composition (f . g)(x) is f(g(x))
    We can write that in Haskell too, using the (.) function

    (.) :: (b -> c) -> (a -> b) -> a -> c  
    f . g = \x -> f (g x)  
-}
function_composition = do
    print $ map (\x -> (+1) ((*2) x)) [1, 2, 3]
    print $ map ((+1) . (*2)) [1, 2, 3]
    print $ map (\xs -> (+1) (sum (tail xs))) [[1, 1, 1], [2, 2, 2], [3, 3, 3]]
    print $ map ((+1) . sum . tail) [[1, 1, 1], [2, 2, 2], [3, 3, 3]]
    print $ map (\xs -> (+1) $ sum $ tail xs) [[1, 1, 1], [2, 2, 2], [3, 3, 3]]


run_differences = do
    let f = (+1)
    let g = (*2)
    print $ (f . g) 2
    print $ f $ g 2

    -- f $ g    => not ok, because f is expecting an Integer as argument, but g is a function
    -- f . g 2  => not ok, beacause we cannot compose f with an Integer (g 2); it sould be a function

square x = x*x
inc x = x+1
f1 x = inc (square x)
f2 x = inc $ square x
f3 x = inc . square $ x
f4 = inc . square

------------------------------------------ POINT-FREE PROGRAMMING --------------------------------------------
sum' :: [Integer] -> Integer
sum' xs = foldl (+) 0 xs

sum'' :: [Integer] -> Integer
sum'' = foldl (+) 0

{-
    flip :: (a -> b -> c) -> b -> a -> c
    flip f x y = f y x

    map :: (a -> b) -> [a] -> [b]
    flip map :: [a] -> (a -> b) -> [b]
-}

flip_example = do
    print $ take 10 (map (*2) [0..])
    print $ take 10 $ map (*2) [0..]
    print $ take 10 $ (flip map) [0..] (*2)
    print $ take 10 $ flip map [0..] (*2)
    let f = flip map [0..]
    print $ take 10 $ f (*3)

myIntersperse :: a -> [a] -> [a]
myIntersperse y = foldr (++) [] . map (: [y])

