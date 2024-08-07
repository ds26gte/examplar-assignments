# include cpo

provide:
  fact-in-ok
end

fact-in-ok = lam(n :: Number) -> Boolean:
  if n >= 0: 
    true
  else:
    false
  end
end
