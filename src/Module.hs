module Module where

import Data.Map (Map)
import Term (Term(..))
import Token (Token(..))

import qualified Data.Map as Map
import qualified Term

type Module = Map String Term

parseTokens :: [Token] -> Maybe ([Token], Module)
parseTokens [] = Just ([], Map.empty)
parseTokens (t : ts) = case t of
  Identifier name -> case ts of
    Colon : ts -> case ts of
      Equals : ts -> do
        (ts, term) <- Term.parseTokens ts
        (ts, mapping) <- parseTokens ts
        Just (ts, Map.insert name term mapping)
      _ -> Nothing
    _ -> Nothing
  _ -> Nothing

substitute :: Module -> Term -> Term
substitute mod term = go term []
  where
    go :: Term -> [String] -> Term
    go term bound = case term of
      Variable name ->
        if elem name bound then
          term
        else
          go (Map.findWithDefault term name mod) bound
      Abstraction parameter body ->
        Abstraction parameter $ go body (parameter : bound)
      Application function argument ->
        Application (go function bound) (go argument bound)

execute :: Module -> Maybe Term
execute mod
  =   Term.evaluate
  <$> substitute mod
  <$> Map.lookup "main" mod
