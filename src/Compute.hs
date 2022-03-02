--
-- EPITECH PROJECT, 2022
-- B-FUN-400-LIL-4-1-wolfram-thibault2.brumaire
-- File description:
-- Compute
--

{-# LANGUAGE DeriveFunctor #-}

-- Compute module
module Compute where

-- Imports
import Args ( Settings(..) )
import Control.Comonad ( (=>>), Comonad(extract, duplicate) )
import InfList (InfList (..), (+++))
import qualified InfList as I

-- Types

data IList a = IList (InfList a) a (InfList a) deriving Functor

type Rule a = (a -> a -> a -> a)

-- Run wolfram
wolfram :: Settings -> IO ()
wolfram Settings {rId = r, start = s, nbLines = l, width = w, move = m} =
    dList l w (getRule r) (getIter (getRule r) s) m

-- display the Infinit List
dList :: (Eq a, Num a) => Int -> Int -> Rule a -> IList a -> Int -> IO ()
dList (-1) w r i m = mapM_ putStrLn $ dLine w r i m
dList l w r i m = mapM_ putStrLn $ take l $ dLine w r i m

-- display the line of the Infinit List
dLine :: (Eq a, Num a) => Int -> Rule a -> IList a -> Int -> [[Char]]
dLine w r l m = fmap dChar . view w m <$> runLine r l

-- Get the current line with boundaries
view :: Int -> Int -> IList a -> [a]
view n m (IList l x r) = reverse (I.take (n + m) l) ++ [x] ++ I.take (n - m) r

-- Get the rule
getRule :: (Integral a, Integral b) => a -> b -> b -> b -> a
getRule n l x r = n `div` (2 ^ (2 * x + 4 * l + r)) `mod` 2

-- Get current iteration
getIter :: Num t => Rule t -> Int -> IList t
getIter r 1 = convertList [1]
getIter r x = getIter r (x-1) =>> getStep r

-- Get current step
getStep :: (t1 -> t1 -> t1 -> t2) -> IList t1 -> t2
getStep rule (IList (l ::: _) x (r ::: _)) = rule l x r

-- Infinite list comonad
instance Comonad IList where
    extract (IList _ x _) = x
    duplicate x = IList (getRewind getLeft x) x (getRewind getRight x)

getRewind :: (a -> a) -> a -> InfList a
getRewind dir = I.iterate dir . dir

getRight :: IList a -> IList a
getRight (IList l x (r ::: rs)) = IList (x ::: l) r rs

getLeft :: IList a -> IList a
getLeft  (IList (l ::: ls) x r) = IList ls l (x ::: r)

-- Iterate on the rule
runLine :: Rule t -> IList t -> [IList t]
runLine r = iterate (=>> getStep r)

-- Converters
dChar :: (Eq a, Num a) => a -> Char
dChar 0 = ' '
dChar _ = '*'

convertList :: Num a => [a] -> IList a
convertList [] = convertList [0]
convertList (x:xs) = let iZeros = I.repeat 0 in IList iZeros x (xs +++ iZeros)