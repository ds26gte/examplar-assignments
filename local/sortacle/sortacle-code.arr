provide { generate-input: generate-input, is-valid: is-valid, oracle: oracle } end

include my-gdrive("sortacle-common.arr")

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in this file.

fun generate-input(n :: Number) -> List<Person>:
  ...
end

fun is-valid(original :: List<Person>, sorted :: List<Person>) -> Boolean: 
  ...
end

fun oracle(sorter :: (List<Person> -> List<Person>)) -> Boolean:
  ...
end