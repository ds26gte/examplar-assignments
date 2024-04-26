import file("../fact-qtm.arr") as QTM
provide from QTM: * end

provide:
  *,
  type *
end

fun fact(n :: Number) -> Number:
  n + 1
end

