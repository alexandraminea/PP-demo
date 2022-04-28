
--------------------------------- LAZY EVALUATION (recap) ------------------------------
{-
    *Main> l1 = [1..] :: [Int]
    *Main> :sprint l1
    l1 = _
    *Main> head l1
    1
    *Main> :sprint l1
    l1 = 1 : _
    *Main> take 5 l1
    [1,2,3,4,5]
    *Main> :sprint l1
    l1 = 1 : 2 : 3 : 4 : 5 : _
    *Main> l1 !! 10
    11
    *Main> :sprint l1
    l1 = 1 : 2 : 3 : 4 : 5 : 6 : 7 : 8 : 9 : 10 : 11 : _
-}


-- exmaples from http://learnyouahaskell.com/making-our-own-types-and-typeclasses#algebraic-data-types

------------------------------------- DATA TYPES ---------------------------------------

------------------------------------- enumarated ---------------------------------------

data Shape = Circle Float Float Float | Rectangle Float Float Float Float

-- :t Circle

surface :: Shape -> Float  
surface (Circle _ _ r) = pi * r ^ 2  
surface (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)

-- surface $ Circle 10 20 10  
-- surface $ Rectangle 0 0 100 100  

-- !!! We can't use constructors as data types
-- f :: Circle -> Float
-- f shape = undefined

-- Circle 2.0 3.0 2.0 => an error in the terminal => we should use 'deriving (Show)'

-- We can use the same name for the data type and the constructor, in this case 'Point'
data Point = Point Float Float deriving (Show)

-- Now, the new 'Shape' data type would look like this:

data Shape2 = Circle2 Point Float | Rectangle2 Point Point deriving (Show)

surface2 :: Shape2 -> Float  
surface2 (Circle2 _ r) = pi * r ^ 2  
surface2 (Rectangle2 (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)

-- surface2 $ Circle2 (Point 10 20) 10
-- surface2 $ Rectangle2 (Point 0 0) (Point 100 100)

---- RECORD SYNTAX ----

data Person = Person String String Int Float String String deriving (Show)

guy = Person "Buddy" "Finklestein" 43 184.2 "526-2928" "Chocolate" 

firstName :: Person -> String  
firstName (Person firstname _ _ _ _ _) = firstname
  
lastName :: Person -> String  
lastName (Person _ lastname _ _ _ _) = lastname
  
age :: Person -> Int  
age (Person _ _ age _ _ _) = age
  
height :: Person -> Float  
height (Person _ _ _ height _ _) = height
  
phoneNumber :: Person -> String  
phoneNumber (Person _ _ _ _ number _) = number
  
flavor :: Person -> String  
flavor (Person _ _ _ _ _ flavor) = flavor


-- we can do better

------------------------------------- record syntax ------------------------------------

data Person2 = Person2 { firstName2 :: String
                        , lastName2 :: String
                        , age2 :: Int
                        , height2 :: Float
                        , phoneNumber2 :: String
                        , flavor2 :: String
                        } deriving (Show)

another_guy = Person2 "Guy" "Smith" 23 136.4 "secret" "Strawberry"

-- firstName2 another_guy
-- lastName2 another_guy

same_guy = Person2 {firstName2 = "Buddy", 
                    lastName2 =  "Finklestein",
                    age2 = 43,
                    height2 =  184.2,
                    phoneNumber2 = "526-2928",
                    flavor2 =  "Chocolate" }

change_flavor :: Person2 -> String -> Person2
change_flavor p new_flavor = p {flavor2 = new_flavor}

-- change_flavor same_guy "Vanilla"

------------------------------------- parametrized -------------------------------------

-- data Maybe a = Nothing | Just a

myHead :: [a] -> Maybe a
myHead [] = Nothing
myHead (x:xs) = Just x

myTail :: [a] -> Maybe [a]
myTail [] = Nothing
myTail (x:xs) = Just xs

foo :: [a] -> Maybe a
foo xs = case myTail xs of
    Nothing -> Nothing
    Just a -> case myTail a of
        Nothing -> Nothing
        Just b -> myHead b


data MyEither a b = MyLeft a | MyRight b deriving (Show)

pairOff :: Int -> Either String Int
pairOff people
    | people < 0  = Left "Can't pair off negative number of people."
    | people > 30 = Left "Too many people for this activity."
    | even people = Right (people `div` 2)
    | otherwise   = Left "Can't pair off an odd number of people."

groupPeople :: Int -> String
groupPeople people =
    case pairOff people of
        Right groups -> "We have " ++ show groups ++ " group(s)."
        Left problem -> "Problem! " ++ problem


------------------------------------- recursive ---------------------------------------

data List a = Void | Cons a (List a) deriving Show
l1 = Cons 5 (Cons 6 Void)

data List2 a = Empty | Cons2 { listHead :: a, listTail :: List2 a} deriving (Show)
l2 = Cons2 5 (Cons2 6 Empty)

{-
  tlistToList transformă o TList într-o listă Haskell
-}
tlistToList :: List a -> [a]
tlistToList Void = []
tlistToList (Cons x y) = x : tlistToList y

{-
  listToTList transformă o TList într-o listă Haskell
-}
listToTList :: [a] -> List a
listToTList [] = Void
listToTList (x:xs) = Cons x (listToTList xs)


---------------------------------------- newtype ---------------------------------------

-- newtype is similar to data, but it accepts only one constructor

newtype Natural = MakeNatural Integer deriving Show

toNatural :: Integer -> Natural
toNatural x
    | x < 0     = error "Can't create negative naturals!" 
    | otherwise = MakeNatural x

newtype PairT a b = PairC (a,b) deriving Show

fstPair (PairC p) = fst p
sndPair (PairC p) = snd p

------------------------------------ TYPE SYNONIMS -------------------------------------

phoneBook :: [(String,String)]  
phoneBook =      
    [("betty","555-2938")     
    ,("bonnie","452-2928")     
    ,("patsy","493-2928")     
    ,("lucille","205-2928")     
    ,("wendy","939-8282")     
    ,("penny","853-2492")     
    ]

type PhoneBook = [(String, String)]

addPhoneNumber :: PhoneBook -> String -> String -> PhoneBook
addPhoneNumber pb name number = (name, number) : pb

-- addPhoneNumber phoneBook "alexandra" "secret number"

type Name = String
type PhoneNumber = String

type PhoneRecords = [(Name, PhoneNumber)]

inPhoneBook :: Name -> PhoneNumber -> PhoneBook -> Bool  
inPhoneBook name pnumber pbook = (name,pnumber) `elem` pbook

-- inPhoneBook "betty" "555-2938" phoneBook

-- We don't create new types, we just give new names to other types for expresivness


----------------------------------- BINARY SEARCH TREE --------------------------------


data BSTree a = EmptyTree | Node a (BSTree a) (BSTree a) deriving (Show)

singleton :: a -> BSTree a  
singleton x = Node x EmptyTree EmptyTree  

t1 = Node 5 (Node 3 (singleton 1) (singleton 4)) (Node 7 (singleton 6) (singleton 8))
t2 = Node 5 (singleton 3) (singleton 6)

-- inserts a node in Tree
treeInsert :: (Ord a) => a -> BSTree a -> BSTree a  
treeInsert x EmptyTree = singleton x  
treeInsert x (Node a left right)   
    | x == a = Node x left right  
    | x < a  = Node a (treeInsert x left) right  
    | x > a  = Node a left (treeInsert x right)

t3 = treeInsert 2 t2
-- treeInsert 2 (Node 5 (Node 3 EmptyTree EmptyTree) (Node 6 EmptyTree EmptyTree))  // x = 2, a = 5
-- Node 5 (treeInsert 2 (Node 3 EmptyTree EmptyTree)) (Node 6 EmptyTree EmptyTree)  // x = 2, a = 3
-- Node 5 (Node 3 (treeInsert 2 EmptyTree) EmptyTree) (Node 6 EmptyTree EmptyTree)  // x = 2, EmptyTree
-- Node 5 (Node 3 (singleton 2) EmptyTree) (Node 6 EmptyTree EmptyTree)
-- Node 5 (Node 3 (Node 2 EmptyTree EmptyTree) EmptyTree) (Node 6 EmptyTree EmptyTree)

t4 = treeInsert 4 t2

-- checks if a node is in the Tree
treeElem :: (Ord a) => a -> BSTree a -> Bool  
treeElem x EmptyTree = False  
treeElem x (Node a left right)  
    | x == a = True  
    | x < a  = treeElem x left  
    | x > a  = treeElem x right

toList :: BSTree a -> [a]
toList EmptyTree = []
toList (Node x left right) = [x] ++ (toList left) ++ (toList right)

fromList :: (Ord a) => [a] -> BSTree a
fromList nodes = foldr treeInsert EmptyTree nodes


------------------------------------- NESTED LISTS -------------------------------------

data NestedList a = Elem a | List [NestedList a]

instance Show a => Show (NestedList a) where
    show (Elem x) = show x
    show (List xs) = show xs

nl1 = List [Elem 1, List [List [Elem 2, Elem 3], Elem 4] , Elem 5]

deepEqual :: Eq a => NestedList a -> NestedList a -> Bool
deepEqual (Elem x) (Elem y) = x == y
deepEqual (List a) (List b) = and $ zipWith deepEqual a b
deepEqual _ _               = False

{-
    Hint: concat :: [[a]] -> [a]
    ex: concat [[1, 2], [3, 4]] = [1, 2, 3, 4]
-}
flatten (Elem x)    = [x]
flatten (List xs)   = concat $ map flatten xs
                    -- = concatMap flatten xs

