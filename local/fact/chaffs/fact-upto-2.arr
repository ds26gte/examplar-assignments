import file("../fact-qtm.arr") as QTM
provide from QTM: * end

provide:
  *,
  type *
end

fun fact(n :: Number) -> Number:
  if n == 0:
    1
  else if n == 1:
    1
  else: 
    2
  end
end

