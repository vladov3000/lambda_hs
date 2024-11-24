## lambda_hs

This is a lambda calculus interpreter implemented in Haskell.
To build the program, have `ghc` installed and run `./build.sh`. The output binary will be in `out/lambda_hs`.
You can run the program on the example with `lambda_hs out/basic.l`. The program will be parsed and the term `main` will be evaluated, and the resulting term will be printed.

The language is already strictly more powerful than its host language Haskell, because it can describe and use the Y combinator while Haskell has to rely on `fix` due to its type system. You can encode algebraic data types with functions, for example integers:
```
zero      := \z.\s.z
increment := \n.\z.\s.(s n)
```
And use recursion to implement more interesting functions:
```
addP      := \f.\x.\y.(x y \n.(increment (f f n y)))
add       := (Y addP)
```
Theoretically, you only need to be able to encode bitstrings, and recursive functions on them to simulate any program (with a few corner cases), so this is a complete programming language.
