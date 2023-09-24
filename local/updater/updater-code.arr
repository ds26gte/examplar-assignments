include cpo

provide {find-cursor: find-cursor, get-node-val: get-node-val, update: update,
  to-tree: to-tree, left: left, right: right, up: up, down: down} end

include file("updater-common.arr")
include file("updater-types.arr")

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions)
# in this file.

# You will come up with a Cursor definition, which may have more than
# one variant, and can have whatever fields you need
data Cursor<A>:
    # "dummy-cursor" doesn't mean anything, and you should replace it
    # with your own definition
  | dummy-cursor(tree :: Tree<A>)
end

fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A>:
  ...
end

fun up<A>(cur :: Cursor<A>) -> Cursor<A>:
  ...
end

fun left<A>(cur :: Cursor<A>) -> Cursor<A>:
  ...
end

fun right<A>(cur :: Cursor<A>) -> Cursor<A>:
  ...
end

fun down<A>(cur :: Cursor<A>, child-index :: Number ) -> Cursor<A>:
  ...
end

fun update<A>(cur :: Cursor<A>, func :: (Tree<A> -> Tree<A>)) -> Cursor<A>:
  ...
end

fun to-tree<A>( cur :: Cursor<A> ) -> Tree<A>:
  ...
end

fun get-node-val<A>(cur :: Cursor<A>) -> Option<A>: 
  ...
end
