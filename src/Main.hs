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

parseSourcePath :: [String] -> IO String
parseSourcePath arguments =
  case arguments of
    [] -> do
      putStrLn "Expected exactly one argument.\nUsage: lambda_hs SOURCE_PATH\n"
      exitFailure
    (path : _) -> pure path

main :: IO ()
main = do
  args <- getArgs
  sourcePath <- parseSourcePath args
  source <- readFile sourcePath
  case parse Module.parseTokens source of
    Just mod -> case Module.execute mod of
      Just term -> print term
      Nothing -> putStrLn "Execution failure."
    Nothing -> putStrLn "Parsing failure."

