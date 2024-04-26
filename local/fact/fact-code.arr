import file("fact-qtm.arr") as QTM
provide from QTM: * end

provide {fact: fact} end
provide-types *

fun fact(n :: Number) -> Number:
 ...
end

