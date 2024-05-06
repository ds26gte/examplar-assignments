# include cpo

provide:
  fact-in-ok
end

fun fact-in-ok(n :: Number) -> Boolean:
  if n >= 0: 
    true
  else:
    false
  end
end
