include cpo
provide {how-many: how-many, du-dir: du-dir, can-find: can-find, fynd: fynd} end
include file("filesystem-types.arr")
include file("filesystem-common.arr")

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in
# this file.

fun how-many(a-dir :: Dir) -> Number:
  ...
end

fun du-dir(a-dir :: Dir) -> Number:
  ...
end

fun can-find(a-dir :: Dir, fname :: String) -> Boolean:
  ...
end

fun fynd(a-dir :: Dir, fname :: String) -> List<Path>:
  ...
end
