--
-- EPITECH PROJECT, 2022
-- B-FUN-400-LIL-4-1-wolfram-thibault2.brumaire
-- File description:
-- Main
--

-- main module
module Main where

-- imports
import Args ( testNull, testArgs, getSettings )
import Compute ( wolfram )
import System.Environment ( getArgs )

main :: IO ()
main = do
    args <- getArgs
    testNull args
    testArgs args
    wolfram (getSettings args)
