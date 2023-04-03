module Term (Term(..), parseTokens, evaluate) where

import Data.Bifunctor (first)
import Data.List (find)
import Data.Maybe (listToMaybe)

import Token (Token(..))

data Term
  = Variable String
  | Abstraction String Term
  | Application Term Term

instance Show Term where
  show term = case term of
    Variable name -> name
    Abstraction parameter body ->
      "\\" <> parameter <> "." <> show body
    Application function argument ->
      "(" <> show function <> " " <> show argument <> ")"

parseTokens :: [Token] -> Maybe ([Token], Term)
parseTokens [] = Nothing
parseTokens (t : ts) = case t of
  Identifier s -> Just $ (ts, Variable s)
  Backslash -> case ts of
    Identifier parameter : ts -> case ts of
      Dot : ts -> (fmap $ Abstraction parameter) <$> parseTokens ts
      _ -> Nothing
    _ -> Nothing
  LParen -> do
    (ts, function) <- parseTokens ts
    (ts, argument) <- parseTokens ts
    go (Application function argument) ts
    where
      go :: Term -> [Token] -> Maybe ([Token], Term)
      go term tokens = case tokens of
        RParen : tokens -> Just (tokens, term)
        _ -> do
          (tokens, argument) <- parseTokens tokens
          go (Application term argument) tokens
  _ -> Nothing

substitute :: String -> Term -> Term -> Term
substitute variable value term =
  case term of
    Variable name -> if name == variable then value else term
    
    Abstraction parameter body ->
      if parameter == variable then
        term
      else
        Abstraction parameter $ substitute variable value body
        
    Application function argument ->
      Application
      (substitute variable value function)
      (substitute variable value argument)

evaluate :: Term -> Term
evaluate term = case term of
  Variable _ -> term
  Abstraction _ _ -> term
  Application function argument ->
    let function' = evaluate function
        argument' = evaluate argument in
      case function' of
        Abstraction parameter body ->
          evaluate $ substitute parameter argument body
        _ -> Application function' argument'


