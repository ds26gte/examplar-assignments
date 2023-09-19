include cpo
include file("filesystem-code.arr")

include file("filesystem-types.arr")

#lmayo1 - function to create a string of 'a's of length l
fun string-of-len(l :: Number):
  range(0, l).foldr(lam(x, acc): string-append("a", acc) end, "")
where:
  string-of-len(0) is ""
  string-of-len(1) is "a"
  string-of-len(5) is "aaaaa"
end

# data
FS1 = dir("empty", empty, empty)

FS2 = dir("top", empty, [list: 
    file("a", string-of-len(1)), 
    file("b", string-of-len(2)), 
    file("c", string-of-len(3)), 
    file("d", string-of-len(4))]) 

FS3 = dir("top", 
  [list:
    dir("mid-a", empty, [list:
        file("a", string-of-len(1)), 
        file("b", string-of-len(2)), 
        file("c", string-of-len(3)), 
        file("d", string-of-len(4))]),
    dir("mid-b", 
      [list: 
        dir("low-b-a", empty, [list: file("a", string-of-len(9000))]),
        dir("low-b-b", empty, [list: file("powerlevel", string-of-len(9001))])], 
      [list: 
        file("a", string-of-len(1)),
        file("b", string-of-len(2)),
        file("c", string-of-len(3))])],
  [list: file("a", string-of-len(4)),
    file("b", string-of-len(5))])

FS4 = dir("top", [list:
    dir("mid-a", empty, [list:
        file("a", string-of-len(1)),
        file("b", string-of-len(2)),
        file("c", string-of-len(3)),
        file("d", string-of-len(4))]),
    dir("mid-b", [list:
        dir("low-b-a", empty, [list: file("a", string-of-len(9000))]),
        dir("low-b-b", empty, [list: file("powerlevel",string-of-len(9001))])],
      empty)],
  empty)

FS5 = dir("top", [list:
    dir("mid-a", [list:
        dir("low-a-a", [list:
            dir("lower-a-a-a", empty, empty),
            dir("lower-a-a-b", [list:
                dir("lowest-a-a-b-a", empty, empty)], empty),
            dir("lower-a-a-c", empty, empty)], empty),
        dir("low-a-b", empty, empty),
        dir("low-a-c", empty, empty)], empty),
    dir("mid-b", [list:
        dir("low-b-a", empty, empty)], empty),
    dir("mid-c", empty, empty)], empty)

FS6 =
  dir("top", [list:
      dir("mid", [list:
          dir("low", [list:
              dir("lowest", empty, [list:
                  file("d", string-of-len(5))])],
            empty)],
        empty)],
    empty)

tree1-desc = "empty tree"
tree2-desc = "4 files, 0 dirs"
tree3-desc = ```11 files, 4 dirs, 3 levels (including top), 
             at least 1 file in each dir```
tree4-desc = ```6 files, 4 dirs, 3 levels (including top), 
             some with files, some without```
tree5-desc = "0 files, 11 dirs, 5 levels (including top)"
tree6-desc = ```1 file, 4 dirs, 4levels (including top),
             all dirs empty except very bottom```


check "how-many-normal:: how-many tests":
  # should be 4 for a dir with 4 files on top level
  how-many(FS2) is 4

  # handles subdir recursion by counting every leaf
  how-many(FS3) is 11

  # handles subdir recursion by handling missing leaves
  how-many(FS4) is 6
end


check "du-dir-normal:: du-dir tests":
  # sums the file-sizes correctly
  du-dir(FS2) is 14


  # recurs through the subdirs properly and adds both length of file list and 
  # length of dirs list
  du-dir(FS3) is (18001 + 25 + 11 + 4)


  # recurs through subdirs some of which have files and some of which do not
  du-dir(FS4) is (18001 + 10 + 6 + 4)


  # recurs through subdirs, handling the case of no files
  du-dir(FS5) is 11
end

check "can-find-normal:: can-find tests":
  # finds first file in a one level dir
  can-find(FS2, "a") is true


  # finds a file within a one level dir
  can-find(FS2, "b") is true


  # finds first file within a 3 level tree
  can-find(FS3, "a") is true


  # finds a deeper file within the subdirs of a 3 level tree
  can-find(FS3, "c") is true


  # finds a file within the sub-subdirs of a 3 level tree
  can-find(FS3, "powerlevel") is true


  # returns false for a file not in the dir
  can-find(FS3, "foo") is false


  # finds lower level element in a large tree
  can-find(FS4, "a") is true
end

check "no-dirs:: Makes sure can-find and how-many only look at files":
  # does not find the name of the top-level directory
  can-find(FS5, "top") is false

  # finds files but not directories
  can-find(FS4, "mid-a") is false

  # does not count dirs as files
  how-many(FS5) is 0
end

check ```1-3-empty:: Tests to see if the first three functions can handle 
      empty inputs```:
  # can-find gets false for a file not found in a one level dir
  can-find(FS2, "foo") is false

  # du-dir should be 0 for an empty dir
  du-dir(FS1) is 0

  # should be 0 for empty dir
  how-many(FS1) is 0
end

check "fynd-normal:: Tests normal fynd operation":
  # finds correct paths for files that matches filename in 3 level tree
  solutions1 = [list: [list: "top", "mid-a"], [list: "top", "mid-b", "low-b-a"],
    [list: "top", "mid-b"], [list: "top"]]
  fold(lam(acc, cur): acc and solutions1.member(cur) end, true, fynd(FS3, "a"))
    is true


  # finds every correct path for every file that matches filename in 
  # 3 level tree
  list-to-set(solutions1) is list-to-set(fynd(FS3, "a"))


  # finds correct paths for every file that matches filename in 3 level tree
  solutions2 = [list: [list: "top", "mid-a"], [list: "top", "mid-b"], 
    [list: "top"]]
  fold(lam(acc, cur): acc and solutions2.member(cur) end, true, fynd(FS3, "b"))
    is true

  list-to-set(solutions2) is list-to-set(fynd(FS3, "b"))


  # finds correct paths for every file that matches filename in 3 level tree
  solutions3 = [list: [list: "top", "mid-a"], [list: "top", "mid-b"]]
  fold(lam(acc, cur): acc and solutions3.member(cur) end, true, fynd(FS3, "c"))
    is true

  list-to-set(solutions3) is list-to-set(fynd(FS3, "c"))

  # finds correct path to file in many empty directories
  fynd(FS6, "d") is [list: [list: "top", "mid", "low", "lowest"]]


  # does not return any paths when file not found
  fynd(FS3, "e") is empty
  fynd(FS5, "a") is empty
  fynd(FS5, "b") is empty

  # returns empty if only directories match search
  fynd(FS6, "mid") is empty


  # does not return any paths for an empty tree
  fynd(FS1, "top") is empty
end
