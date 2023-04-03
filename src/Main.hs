module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure)
import Term (Term, evaluate)
import Token (Token(..), tokenize)

import qualified Module

parse :: ([Token] -> Maybe ([Token], a)) -> String -> Maybe a
parse parseTokens s = do
  tokens <- tokenize s
  (rest, result) <- parseTokens tokens
  if null rest then Just result else Nothing

main :: IO ()
main = do
  args <- getArgs
  source <- readFile $ head args
  case parse Module.parseTokens source of
    Just mod -> case Module.execute mod of
      Just term -> print term
      Nothing -> putStrLn "Execution failure."
    Nothing -> putStrLn "Parsing failure."

