include cpo

import file("updater-code.arr") as solution

import file("wheats/updater-wheat.arr") as true-solution
include file("updater-types.arr")
import either as Eth

find-cursor = solution.find-cursor
to-tree = solution.to-tree
update = solution.update
up = solution.up
down = solution.down
left = solution.left
right = solution.right
get-node-val = solution.get-node-val

#test data
node0 = node(0, empty)
node1 = node(1, empty)
node2 = node(2, empty)
node3 = node(3, empty)
node4 = node(4, empty)
node5 = node(5, empty)

tree1 = node(5, [list: node0])

tree2 = node(5, [list: node1, node5, node3])

tree3 = node(6, [list: node0, node3, tree2, node5])
tree4 = node(6, [list: node4, node3, tree3, node3, tree1, node4])
tree5 = node(6, [list: node0])
tree7 = node(5, [list: node(5, [list: node0])])
tree16 = node(6, [list: node3, node5])
tree17 = node(6, [list: node0, tree2, node5])


ex1 = node(0, [list: 
    node(1, [list: node(3, [list: node(7, empty), node(8, empty)])]),
    node(2, [list: 
        node(4, empty), 
        node(5, [list: node(9, empty)]),
        node(6, [list: node(10, empty), node(11, empty)])])])
ex2 = node(0, [list:
    node(1, empty), 
    node(2, [list: node(3, empty), node(4, empty)])])

# Bad trees b/c they have `mt` in them
tree1-with-mts =  node(5, [list: node0, mt])
tree4-with-mts = node(6, [list: node4, mt, node3, tree3, node3, tree1-with-mts, node4])

#Test Suites

check "get-node-val:: Get node val checks for non-mt nodes":
  #one node
  get-node-val(find-cursor(node5, lam(x): x == 5 end)) is some(5)
  #actual tree
  get-node-val(find-cursor(tree17, lam(x): x == 3 end)) is some(3)
  #empty node
  get-node-val(update(find-cursor(tree1, lam(x): x == 0 end), lam(t): mt end)) is none
end

# find-cursor

check "find-cursor-normal-cases :: basic functionality checks for find-cursor":
  #singleton
  get-node-val(find-cursor(node0, lam(x): x == 0 end)) is some(0)
  #one child node
  get-node-val(find-cursor(tree1, lam(x): x == 0 end)) is some(0)
  #multiple child nodes
  get-node-val(find-cursor(tree2, lam(x): x == 1 end)) is some(1)
  #larger tree
  get-node-val(find-cursor(tree3, lam(x): x == 1 end)) is some(1)
  #empty tree
  find-cursor(mt, lam(x): is-node(x) end) raises ""
  #false predicate
  find-cursor(tree1, lam(x): false end) raises ""
  #insatsifiable predicate
  find-cursor(ex1, {(x): x < 0}) raises ""
end

check "find-cursor-tree-with-duplicates :: find-cursoring a tree with duplicates, they should find-cursor using depth first search, and find the topmost one if there's multiple leftmost ones":
  treedup = node(5, [list: node5, node(6, [list: node(4, [list: node1]), node5, node3]), node2, node0])
  get-node-val(find-cursor(treedup, lam(x): x < 5 end)) is some(4)
end

#->tree

check "to-tree-normal-cases :: normal to tree functionality on simple and more complext trees":
  #simple tree
  to-tree(find-cursor(tree3, lam(x): x == 5 end)) is tree3
  #complex tree
  to-tree(find-cursor(tree4, lam(x): x == 5 end)) is tree4
  #empty tree
  to-tree(update(find-cursor(node0, lam(x): x == 0 end), lam(x ): mt end)) is mt
end

#update

fun pred5(x): x == 5 end

check "update-delete:: delete by replacing with mt-node, relies on to-tree and find-cursor":
  to-tree(update(find-cursor(tree1, lam(x): x == 0 end ), lam(x): mt end)) is 
  to-tree(find-cursor(node5, lam(x): x == 5 end))
end


check "update-normal-cases:: simple functionality test for update, relies on find-cursor":
  get-node-val(update(find-cursor(tree3, pred5), lam(x): tree1 end)) is some(5)
  to-tree(update(find-cursor(tree3, lam(x): x == 6 end), lam(x): tree1 end)) is tree1
  to-tree(up(down(update(find-cursor(tree1, lam(x): x == 0 end), lam(x): tree1 end),  0))) is tree7
  to-tree(update(left(left(update(find-cursor(tree3, pred5), lam(x): mt end))), lam(x): mt end)) is tree16
  to-tree(update(up(down(update(find-cursor(tree3, lam(x): x == 3 end), lam(x): tree1 end), 0)), lam(x): mt end)) is tree17
  to-tree(update(find-cursor(tree1, pred5), lam(x): node(6, x.children) end)) is tree5
end

check "update twice in a row":
  get-node-val(update(update(find-cursor(tree3, pred5), lam(x): tree1 end), lam(x): tree1 end)) is some(5)
end

#left

check "right-left-normal-cases:: normal cases for right and left":
  get-node-val(left(find-cursor(tree2, lam(x): x == 3 end))) is some(5)
  get-node-val(left(left(find-cursor(tree2, lam(x): x == 3 end)))) is some(1)
  get-node-val(left(right(find-cursor(tree2, lam(x): x == 1 end)))) is some(1)
  get-node-val(right(find-cursor(tree2, lam(x): x == 1 end))) is some(5)
  get-node-val(right(right(find-cursor(tree2, lam(x): x == 1 end)))) is some(3)
end
check "right-left-too-far:: check error moving left or right too far":
  left(find-cursor(tree2, lam(x): x == 1 end)) raises ""
  right(find-cursor(tree2, lam(x): x == 3 end)) raises ""
end


#up

check "up-down-normal-cases:: standard up and down movement":
  get-node-val(up(find-cursor(tree4, lam(x): x == 1 end))) is some(5)
  get-node-val(up(up(find-cursor(tree4, lam(x): x == 1 end)))) is some(6)
  #index 0
  get-node-val(down(find-cursor(tree4, lam(x): x == 6 end), 0)) is some(4)
  #index 3
  get-node-val(down(find-cursor(tree4, lam(x): x == 6 end), 3)) is some(3)
  get-node-val(down(down(find-cursor(tree4, lam(x): x == 6 end), 2), 0)) is some(0)
  get-node-val(up(down(find-cursor(tree4, lam(x): x == 6 end), 0))) is some(6)
end

check "up-too-far:: check error moving up too far":
  up(find-cursor(node0, lam(x): x == 0 end)) raises ""
end
#down

check "down-edge-cases:: basic edge cases for down":
  #move down once, index too large, should produce an error
  down(find-cursor(tree4, lam(x): x == 6 end), 10) raises "" 
  #move down without children, should produce an error
  down(find-cursor(node0, lam(x): x == 0 end), 0) raises ""
end



# Oracle is intended to function by randomly making moves and
# ensuring that the output of update is correct by comparing it to
# our solution, which is known to be correct.


#HELPERS

#############################Trees for oracles#############################
test-tree-1 = node(66, [list:  node(40, [list:  node(12, [list:  node(33, [list: ])]),  node(92, [list:  node(2, [list: ])]),  node(28, [list: ]),  node(48, [list: ]),  node(51, [list: ]),  node(41, [list: ]),  node(75, [list: ]),  node(64, [list: ]),  node(76, [list: ]),  node(99, [list: ])]),  node(46, [list:  node(88, [list:  node(67, [list: ])]),  node(38, [list:  node(54, [list: ])]),  node(1, [list:  node(65, [list: ]),  node(30, [list: ])]),  node(25, [list:  node(36, [list: ]),  node(35, [list: ])]),  node(58, [list:  node(15, [list: ])]),  node(91, [list: ]),  node(73, [list: ]),  node(79, [list: ]),  node(3, [list: ]),  node(27, [list: ])]),  node(84, [list:  node(98, [list:  node(95, [list: ])]),  node(89, [list:  node(9, [list: ])]),  node(17, [list:  node(14, [list: ])]),  node(37, [list: ]),  node(96, [list: ]),  node(43, [list: ]),  node(49, [list: ]),  node(80, [list: ]),  node(61, [list: ]),  node(7, [list: ])]),  node(13, [list:  node(16, [list: ]),  node(4, [list: ]),  node(32, [list: ]),  node(59, [list: ]),  node(45, [list: ]),  node(83, [list: ])]),  node(20, [list:  node(71, [list: ]),  node(39, [list: ]),  node(60, [list: ]),  node(26, [list: ]),  node(56, [list: ]),  node(85, [list: ]),  node(52, [list: ])]),  node(81, [list:  node(18, [list:  node(72, [list: ]),  node(31, [list: ])]),  node(42, [list:  node(21, [list: ])]),  node(53, [list: ]),  node(57, [list: ]),  node(55, [list: ]),  node(87, [list: ]),  node(29, [list: ]),  node(6, [list: ]),  node(82, [list: ]),  node(78, [list: ])]),  node(93, [list:  node(77, [list: ]),  node(86, [list: ]),  node(62, [list: ]),  node(34, [list: ]),  node(0, [list: ]),  node(24, [list: ]),  node(44, [list: ])]),  node(47, [list:  node(22, [list: ]),  node(11, [list: ]),  node(19, [list: ]),  node(10, [list: ])]),  node(69, [list:  node(90, [list: ]),  node(5, [list: ]),  node(23, [list: ]),  node(74, [list: ])]),  node(97, [list:  node(68, [list: ]),  node(8, [list: ]),  node(70, [list: ]),  node(63, [list: ]),  node(50, [list: ]),  node(94, [list: ])])])

test-tree-2 = node(64, [list:  node(23, [list:  node(46, [list: ]),  node(17, [list: ]),  node(91, [list: ]),  node(18, [list: ]),  node(89, [list: ]),  node(58, [list: ]),  node(45, [list: ]),  node(9, [list: ])]),  node(11, [list:  node(71, [list: ]),  node(7, [list: ]),  node(43, [list: ]),  node(82, [list: ]),  node(87, [list: ]),  node(4, [list: ]),  node(65, [list: ]),  node(31, [list: ]),  node(56, [list: ])]),  node(57, [list:  node(10, [list: ]),  node(84, [list: ]),  node(50, [list: ]),  node(69, [list: ]),  node(68, [list: ]),  node(96, [list: ]),  node(95, [list: ]),  node(94, [list: ]),  node(53, [list: ]),  node(2, [list: ])]),  node(78, [list:  node(83, [list: ]),  node(33, [list: ]),  node(20, [list: ]),  node(88, [list: ]),  node(16, [list: ])]),  node(1, [list:  node(70, [list: ]),  node(14, [list: ]),  node(24, [list: ]),  node(39, [list: ]),  node(63, [list: ]),  node(3, [list: ]),  node(13, [list: ]),  node(38, [list: ]),  node(5, [list: ])]),  node(79, [list:  node(32, [list: ]),  node(85, [list: ]),  node(80, [list: ]),  node(77, [list: ]),  node(6, [list: ]),  node(27, [list: ]),  node(97, [list: ]),  node(42, [list: ]),  node(62, [list: ])]),  node(40, [list:  node(15, [list: ]),  node(98, [list: ]),  node(60, [list: ]),  node(34, [list: ]),  node(54, [list: ]),  node(72, [list: ]),  node(26, [list: ]),  node(73, [list: ]),  node(44, [list: ]),  node(47, [list: ])]),  node(48, [list:  node(75, [list:  node(41, [list: ])]),  node(28, [list: ]),  node(25, [list: ]),  node(8, [list: ]),  node(22, [list: ]),  node(93, [list: ]),  node(61, [list: ]),  node(81, [list: ]),  node(55, [list: ]),  node(92, [list: ])]),  node(90, [list:  node(66, [list:  node(74, [list: ])]),  node(59, [list: ]),  node(76, [list: ]),  node(51, [list: ]),  node(0, [list: ]),  node(49, [list: ]),  node(37, [list: ]),  node(67, [list: ]),  node(21, [list: ]),  node(29, [list: ])]),  node(52, [list:  node(99, [list: ]),  node(36, [list: ]),  node(35, [list: ]),  node(19, [list: ]),  node(30, [list: ]),  node(86, [list: ]),  node(12, [list: ])])])

test-tree-3 = node(70, [list:  node(18, [list:  node(17, [list: ]),  node(24, [list: ]),  node(5, [list: ]),  node(20, [list: ]),  node(40, [list: ]),  node(73, [list: ]),  node(13, [list: ])]),  node(62, [list:  node(52, [list: ]),  node(77, [list: ]),  node(79, [list: ]),  node(23, [list: ]),  node(83, [list: ]),  node(54, [list: ]),  node(22, [list: ]),  node(3, [list: ])]),  node(94, [list:  node(72, [list:  node(27, [list: ])]),  node(42, [list: ]),  node(71, [list: ]),  node(4, [list: ]),  node(86, [list: ]),  node(76, [list: ]),  node(97, [list: ]),  node(57, [list: ]),  node(49, [list: ]),  node(0, [list: ])]),  node(47, [list:  node(85, [list: ]),  node(1, [list: ]),  node(51, [list: ]),  node(96, [list: ]),  node(37, [list: ]),  node(84, [list: ]),  node(59, [list: ]),  node(53, [list: ]),  node(30, [list: ]),  node(65, [list: ])]),  node(45, [list:  node(93, [list: ]),  node(60, [list: ]),  node(31, [list: ]),  node(41, [list: ]),  node(36, [list: ]),  node(2, [list: ]),  node(10, [list: ])]),  node(63, [list:  node(81, [list: ]),  node(25, [list: ]),  node(28, [list: ]),  node(8, [list: ]),  node(12, [list: ])]),  node(50, [list:  node(80, [list:  node(14, [list: ])]),  node(48, [list: ]),  node(34, [list: ]),  node(69, [list: ]),  node(55, [list: ]),  node(43, [list: ]),  node(21, [list: ]),  node(91, [list: ]),  node(64, [list: ]),  node(39, [list: ])]),  node(16, [list:  node(68, [list:  node(56, [list: ])]),  node(29, [list:  node(33, [list: ])]),  node(38, [list:  node(35, [list: ])]),  node(61, [list:  node(44, [list: ])]),  node(32, [list: ]),  node(19, [list: ]),  node(6, [list: ]),  node(92, [list: ]),  node(58, [list: ]),  node(82, [list: ])]),  node(26, [list:  node(95, [list: ]),  node(7, [list: ]),  node(87, [list: ]),  node(66, [list: ]),  node(9, [list: ]),  node(88, [list: ])]),  node(89, [list:  node(78, [list: ]),  node(67, [list: ]),  node(11, [list: ]),  node(46, [list: ]),  node(74, [list: ]),  node(90, [list: ]),  node(75, [list: ]),  node(99, [list: ]),  node(98, [list: ]),  node(15, [list: ])])])

fun get-element(l :: List,  ind :: Number) -> Any :
  cases(List) l:
    | empty => raise("Reached end of list")
    | link(f, r) =>
      if ind == 0: f
      else: get-element(r, ind - 1) end
  end
where:
  get-element(empty, 0) raises "Reached end of list"
  get-element([list: 2, 0], 0) is 2
  get-element([list: 1,4,2,5], 3) is 5    
end

#removes first element in list equal to val
fun remq(l :: List, val :: Any) -> List :
  cases(List) l:
    | empty => l
    | link(f, r) => 
      if f == val:
        r
      else:
        link(f, remq(r, val))
      end
  end
where:
  remq([list: 2, 3, 4], 3) is [list: 2, 4]
  remq(empty, 4) is empty
  remq([list: 1,2,3,4], 1) is [list: 2,3,4]
  remq([list: 1,1,2,3,4], 1) is [list: 1,2,3,4]
end

fun shuffle(l :: List, n :: Number):
  if n == 0:
    l
  else:
    shuffle(shuffle-helper(l), n - 1)
  end
end

fun shuffle-helper(l :: List):
  cases(List) l:
    | empty => empty 
    | link(f,r) => 
      if num-random(2) == 0:
        shuffle-helper(r + [list: f])
      else:
        [list: f] + shuffle-helper(r)
      end
  end
end


#Run tests

# Subtrees for use with update
subtree1 = node(5, [list: node(3, empty), node(1, [list: node(4, empty)])])
subtree2 = node(1, [list: node(3, [list: node(1, empty)]), node(2, [list: node(2, empty)])])
subtree3 = node(7, [list: node(1, [list: node(2, [list: node(5, empty), node(4, empty)])]), node(5, [list: node(2, empty)])])
subtree-list = [list: mt, subtree1, subtree2, subtree3]

# create random movement list
rand-movements1 = [list: down,right,right,left,down,lam(x):update(x,subtree1)end,up,down,down]

rand-movements-true1 = [list: true-solution.down,true-solution.right,true-solution.right,true-solution.left,true-solution.down,lam(x):true-solution.update(x,subtree1)end,true-solution.up,true-solution.down,true-solution.down]

rand-movements2 = [list: down,up,lam(x):update(x,subtree1)end,right,right,right,lam(x):update(x,subtree1)end,down,down,down]

rand-movements-true2 = [list: true-solution.down,true-solution.up,lam(x):true-solution.update(x,subtree1)end,true-solution.right,true-solution.right,true-solution.right,lam(x):true-solution.update(x,subtree1)end,true-solution.down,true-solution.down,true-solution.down]

rand-movements3 = [list: down,down,right,right,right,up,lam(x):update(x,subtree1)end,right,down,up,left,up]

rand-movements-true3 = [list: true-solution.down,true-solution.down,true-solution.right,true-solution.right,true-solution.right,true-solution.up,lam(x):true-solution.update(x,subtree1)end,true-solution.right,true-solution.down,true-solution.up,true-solution.left,true-solution.up]

fun move-cursor(cur, moves :: List):
  cases(List) moves:
    | empty => cur
    | link(f, r) =>
      cases(Eth.Either) run-task(lam(): f(cur) end):
        | left(v) => move-cursor(v, r)
        | right(v) => move-cursor(cur, r)
      end
  end
end

# Ensure that two Trees are equilvalent
fun check-tree-equal(t1 :: Tree, t2 :: Tree) -> Boolean:
  cases(Tree) t1:
    | mt => is-mt(t2)
    | node(val, children) =>
      vals-equal = is-node(t2) and (val == t2.value)
      if (vals-equal):
        childcount-equal = t1.children.length() == t2.children.length()
        if (childcount-equal):
          match-map = for map2(c1 from t1.children, c2 from t2.children):
            check-tree-equal(c1, c2)
          end
          final-result = for fold(res from true, elem from match-map):
            res and elem
          end
          final-result
        else:
          false
        end
      else:
        false
      end
  end
end

check "oracle-1:: first oracle":
  student-cursor = find-cursor(test-tree-1,lam(x):true end)
  our-cursor = find-cursor(test-tree-1,lam(x):true end)
  student-result = move-cursor(student-cursor,rand-movements1)
  our-result = move-cursor(our-cursor,rand-movements-true1)
  check-tree-equal(to-tree(student-result),to-tree(our-result)) is true
end

fun pred(x): x == 39 end

check "oracle-2:: 2nd oracle":
  student-cursor = find-cursor(test-tree-2, pred)
  our-cursor = find-cursor(test-tree-2, pred)
  student-result = move-cursor(student-cursor,rand-movements2)
  our-result = move-cursor(our-cursor,rand-movements-true2)
  check-tree-equal(to-tree(student-result),to-tree(our-result)) is true
end

check "oracle-3:: 3rd oracle":
  student-cursor = find-cursor(test-tree-3,lam(x):x == 15 end)
  our-cursor = find-cursor(test-tree-3,lam(x):x == 15 end)
  student-result = move-cursor(student-cursor,rand-movements3)
  our-result = move-cursor(our-cursor,rand-movements-true3)
  check-tree-equal(to-tree(student-result),to-tree(our-result)) is true
end

######### zespirit's tests ##########
check "find-cursor searches depth-first":
  tree =
    node(1, [list:
        node(3, empty), 
        node(3, [list: 
            node(4, [list: 
                node(7, [list: # <--- for `lam(x): x == 7 end` we should find this
                    node(3, empty),
                    node(2, empty)]),
                node(4, empty)]),
            node(7, empty)]),
        node(7, empty),
        node(5, empty)])

  # We can use the various properties of movement functions to check that
  # find-cursor searches depth-first.
  searched-cursor = find-cursor(tree, lam(x): x == 7 end)

  # Demonstrate position in tree by movement errors (or lack thereof)
  left(searched-cursor) raises "Invalid movement"
  right(searched-cursor) does-not-raise

  # Demonstrate position in tree by surrounding values. At the other nodes with
  # value 7, not all of these tests are true, so this proves the current
  # location of the cursor.
  get-node-val(searched-cursor) is some(7)
  get-node-val(right(searched-cursor)) is some(4)
  get-node-val(down(searched-cursor, 0)) is some(3)
  get-node-val(up(searched-cursor)) is some(4)
end

# up:

check "up raises error when Cursor is at topmost node":
  tree =
    node(1, empty)

  up(find-cursor(tree, lam(_): true end)) raises "Invalid movement"
end

# down:

check "down raises error when Cursor is at node with no children":
  tree =
    node(1, empty)

  cursor-at-one = find-cursor(tree, lam(x): x == 1 end)

  down(cursor-at-one, 0) raises "Invalid movement"

  down(cursor-at-one, -1) raises "Invalid movement"
  down(cursor-at-one, 1) raises "Invalid movement"
  down(cursor-at-one, 5) raises "Invalid movement"
end
