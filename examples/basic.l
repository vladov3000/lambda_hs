
identity := \x.x
compose  := \f.\g.\x.(g (f x))
const    := \x.\y.x

true  := \t.\f.t
false := \t.\f.f
not   := \b.(b false true)
and   := \x.\y.(x y false)
or    := \x.\y.(x true y)
xor   := \x.\y.(x (not y) y)

Y := \f.((\x.f(x x)) (\x.f(x x)))

zero      := \z.\s.z
increment := \n.\z.\s.(s n)
decrement := \n.(n zero identity)
one       := (increment zero)
two       := (increment one)
three     := (increment two)
addP      := \f.\x.\y.(x y \n.(increment (f f n y)))
add       := (Y addP)

main := (decrement (decrement ((add two) zero)))
