--
-- EPITECH PROJECT, 2022
-- B-FUN-400-LIL-4-1-wolfram-thibault2.brumaire
-- File description:
-- InfList
--

-- InfList module
module InfList where

-- Imports
import Prelude hiding (map, iterate, take, repeat)

-- Types
data InfList a = a ::: (InfList a)

instance Functor InfList where fmap = map

-- Functions
map :: (a -> b) -> InfList a -> InfList b
map f (x ::: xs) = f x ::: map f xs

iterate :: (a -> a) -> a -> InfList a
iterate f x = x ::: iterate f (f x)

(+++) :: [a] -> InfList a -> InfList a
[] +++ xs = xs
(x:xs) +++ ys = x ::: (xs +++ ys)

take :: Int -> InfList a -> [a]
take n (x ::: xs)
    | n <= 0 = []
    | otherwise = x : take (n - 1) xs

repeat :: a -> InfList a
repeat x = x ::: repeat x