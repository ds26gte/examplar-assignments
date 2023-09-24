include cpo
# CSCI0190 (Fall 2020)

provide {find-cursor: find-cursor, get-node-val: get-node-val, update: update, to-tree: to-tree, left: left, right: right, up: up, down: down, is-Cursor: is-Cursor} end
provide-types {Cursor :: Cursor}

#| chaff (tdelvecc, Sep 1, 2020): 
    To-tree does not clear out mts before returning.
    Search "CHAFF DIFFERENCE" for changed code.
|#

include file("../updater-types.arr")

import equality as EQ

data Action:
  | Up
  | Down
  | Left
  | Right
  | Update
end

data Cursor<A>:
  | cursor(
      parent-cursor :: Option<Cursor<A>>,
      sub-tree :: Tree<A>, 
      left-trees :: List<Tree<A>>, # inside first
      right-trees :: List<Tree<A>>, # inside first
      actions :: List<Action>) # used to keep track of actions for chaffs
    with:
    method _equals(
        self :: Cursor<A>, 
        other :: Cursor<A>, 
        eq :: (Any, Any -> EQ.EqualityResult)) 
      -> EQ.EqualityResult: 
      EQ.Unknown("Cannot compare cursors.", self, other)
    end
end


fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A>:
  doc: "Constructs cursor at first node where pred(tree.value) returns true"
  fun helper(cur :: Cursor<A>) -> Option<Cursor<A>>:
    doc: "Performs a dfs of the tree located at cursor."
    cases (Tree<A>) cur.sub-tree:
      | mt => none
      | node(value, children) =>
        if pred(value):
          some(cur)
        else:
          # Recur on each child, keeping the first result that is not none.
          for fold(
              result :: Option<Cursor<A>> from none, 
              child-index from range(0, children.length())):
            cases (Option<Cursor<A>>) result:
              | some(_) => result
              | none => helper(down(cur, child-index))
            end
          end
        end
    end
  end
  
  cases (Option<Cursor<A>>) helper(cursor(none, tree, empty, empty, empty)):
    | none => raise("Could not find node matching predicate")
    | some(result) => 
      cases (Cursor<A>) result:
        | cursor(a, b, c, d, _) =>
          cursor(a, b, c, d, empty)
      end
  end
end
  
  

fun up<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: "Returns the parent cursor"
  # Create an updated children list for new cursor
  children :: List<Tree<A>> =
    cur.left-trees.foldl(link, link(cur.sub-tree, cur.right-trees))
      
  cases (Option<Cursor<A>>) cur.parent-cursor:
    | none => raise("Invalid movement")
    | some(parent) =>
      cases (Tree<A>) parent.sub-tree:
        | mt => raise("Shouldn't reach here.")
        | node(value, _) =>
          cursor(
            parent.parent-cursor, 
            node(value, children),
            parent.left-trees,
            parent.right-trees,
            cur.actions.push(Up))
      end
  end
end

fun left<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: "Returns a cursor pointed at the node to the left"
  cases (List<Tree<A>>) cur.left-trees:
    | empty => raise("Invalid movement")
    | link(f, r) =>
      cursor(
        cur.parent-cursor,
        f,
        r,
        link(cur.sub-tree, cur.right-trees),
        cur.actions.push(Left))
  end
end

fun right<A>(cur :: Cursor<A>) -> Cursor<A>:
  doc: "Returns a cursor pointed at the node to the right"
  cases (List<Tree<A>>) cur.right-trees:
    | empty => raise("Invalid movement")
    | link(f, r) =>
      cursor(
        cur.parent-cursor,
        f,
        link(cur.sub-tree, cur.left-trees),
        r,
        cur.actions.push(Right))
  end
end

fun down<A>(cur :: Cursor<A>, child-index :: Number ) -> Cursor<A>:
  doc: "Returns a cursor to a child node specified by the index argument"
  cases (Tree<A>) cur.sub-tree block:
    | mt => raise("Shouldn't reach here.")
    | node(_, children) =>
      when (child-index < 0) or (child-index >= children.length()):
        raise("Invalid movement")
      end

      cursor(
        some(cur),
        children.get(child-index),
        # Reverse so that left can use first of left-trees, not last
        children.take(child-index).reverse(),
        children.drop(child-index + 1),
        cur.actions.push(Down))
  end
end

fun update<A>(cur :: Cursor<A>, func :: (Tree<A> -> Tree<A>)) -> Cursor<A>:
  doc: "Updates the cursor's sub-tree with the given tree function"
  cursor(
    cur.parent-cursor,
    func(cur.sub-tree),
    cur.left-trees,
    cur.right-trees,
    cur.actions.push(Update))
end

fun clean-mts<A>(tree :: Tree<A>) -> Tree<A>:
  doc: "Removes all mt's from a given tree."
  cases (Tree<A>) tree:
    | mt => mt
    | node(value, children) =>
      node(value, children.map(clean-mts).filter(is-node))
  end
end

fun to-tree<A>(cur :: Cursor<A> ) -> Tree<A>:
  doc: "Returns a tree representation of the given cursor and all updates"
  cases (Option<Cursor<A>>) cur.parent-cursor:
    | none => cur.sub-tree
    | some(_) => to-tree(up(cur))
  end
  # CHAFF DIFFERENCE: Does not clean mts.
end

fun get-node-val<A>(cur :: Cursor<A>) -> Option<A>: 
  doc: "Returns the value at the cursor as an option"
  cases (Tree<A>) cur.sub-tree:
    | mt => none
    | node(value, _) => some(value)
  end
end

