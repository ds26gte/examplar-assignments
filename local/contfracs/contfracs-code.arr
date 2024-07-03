provide *
provide-types *

include file("contfracs-common.arr")
include file("contfracs-types.arr")

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in this file.

## Part 1: Streams

# cf-phi :: Stream<Number> = 
# cf-e :: Stream<Number> = 

fun take<T>(s :: Stream<T>, n :: Number) -> List<T>:
  ...
end

fun repeating-stream(numbers :: List<Number>) -> Stream<Number>:
  ...
end

fun threshold(approximations :: Stream<Number>, thresh :: Number)-> Number:
  ...
end

fun fraction-stream(coefficients :: Stream<Number>) -> Stream<Number>:
  ...
end


## Part 2: Options and Terminating Streams

# cf-phi-opt :: Stream<Option<Number>> = 
# cf-e-opt :: Stream<Option<Number>> = 
# cf-pi-opt :: Stream<Option<Number>> = 

fun terminating-stream(numbers :: List<Number>) -> Stream<Option<Number>>:
  ...
end

fun repeating-stream-opt(numbers :: List<Number>) -> Stream<Option<Number>>:
  ...
end

fun threshold-opt(approximations :: Stream<Option<Number>>,
    thresh :: Number) -> Number:
  ...
end

fun fraction-stream-opt(coefficients :: Stream<Option<Number>>)
  -> Stream<Option<Number>>:
  ...
end
