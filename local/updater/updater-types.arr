include cpo

provide:
  *,
  type *,
  data *
end

data Tree<A>:
  | mt
  | node(value :: A, children :: List<Tree<A>>)
end
