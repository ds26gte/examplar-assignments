include cpo

provide: * end

fun fact-in-ok(n :: Number) -> Boolean:
  if n > 20:
    raise("Explored: very large input!")
  else:
    true
  end
end

fun fact(n :: Number) -> Number:
  if n == 0:
    1
  else:
    n * fact(n - 1)
  end
end
