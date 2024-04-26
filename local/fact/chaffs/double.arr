import file("../fact-qtm.arr") as QTM
provide from QTM: * end

provide:
  *,
  type *
end

fun fact(n :: Number) -> Number:
  2 * n
end

