module Token (Token(..), tokenize) where

import Data.Char (isAlpha, isSpace)

data Token
  = Identifier String
  | Backslash
  | Dot
  | LParen
  | RParen
  | Colon
  | Equals
  deriving (Show, Eq)

tokenize :: String -> Maybe [Token]
tokenize "" = Just []
tokenize s@(c : s')
  | isAlpha c = do
      let (identifier, rest) = span isAlpha s
      tokens <- tokenize rest
      Just $ Identifier identifier : tokens
  | c == '\\' = (Backslash :) <$> tokenize s'
  | c == '.'  = (Dot       :) <$> tokenize s'
  | c == '('  = (LParen    :) <$> tokenize s'
  | c == ')'  = (RParen    :) <$> tokenize s'
  | c == ':'  = (Colon     :) <$> tokenize s'
  | c == '='  = (Equals    :) <$> tokenize s'
  | isSpace c = tokenize s'
  | otherwise = Nothing
