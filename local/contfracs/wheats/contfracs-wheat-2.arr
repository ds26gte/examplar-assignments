# CSCI0190 (Fall 2020)

include cpo

provide {
    take: take, repeating-stream: repeating-stream, cf-phi: cf-phi, cf-e: cf-e,
    fraction-stream: fraction-stream, threshold: threshold,
    terminating-stream: terminating-stream, repeating-stream-opt: repeating-stream-opt,
    fraction-stream-opt: fraction-stream-opt, threshold-opt: threshold-opt,
  cf-phi-opt: cf-phi-opt, cf-e-opt: cf-e-opt, cf-pi-opt: cf-pi-opt} end

#| wheat (tdelvecc, Aug 31, 2020): 
    take returns empty on negative input.
    repeating-stream(-opt) infinitely computes on empty input.
    fraction-stream(-opt) returns stream of 0s when 0 coefficient present.
    fraction-stream(-opt) raises an error when other invalid coeffs. present.
    cf-pi-opt defined to many coefficients.
    Seach "WHEAT DIFFERENCE" for changed code.
|#

include file("../contfracs-types.arr")

#|
   Generic stream functions
|#

fun take<A>(stream :: Stream<A>, n :: Number) -> List<A>:
  doc: "Takes the first n elements from stream."
  ask:
    | n > 0 then: link(lz-first(stream), take(lz-rest(stream), n - 1))
    | n == 0 then: empty
      # WHEAT DIFFERENCE: Returns empty on negative input.
    | n < 0 then: empty
  end
end

fun repeating-stream<A>(original :: List<A>) -> Stream<A> block:
  doc: "Creates a stream which repeates the given list."
  
  if is-empty(original):
    # WHEAT DIFFERENCE: Computes infinitely for empty list.
    repeating-stream(original)
  else:
    fun helper(remaining :: List<A>) -> Stream<A>:
      cases (List<A>) remaining:
        | empty => helper(original)
        | link(f, r) => lz-link(f, {(): helper(r)})
      end
    end

    helper(original)
  end
end

fun repeating-stream-opt<A>(lis :: List<A>) -> Stream<Option<A>>:
  doc: "Creates a repeating stream of lis, wrapped in some's."
  lz-map(some, repeating-stream(lis))
end

fun terminating-stream<A>(lis :: List<A>) -> Stream<Option<A>>:
  doc: "Creates a stream which starts with lis, and returns nones after."
  cases (List<A>) lis:
    | empty => repeating-stream([list: none])
    | link(f, r) => lz-link(some(f), {(): terminating-stream(r)})
  end
end


#|
   ContFrac functions
|#

# fraction-stream

fun fraction-stream-opt(stream :: Stream<Option<Number>>) -> Stream<Option<Number>>:
  doc: ```Creates a stream of fractions from a given contfrac stream,
          with nones after the last provided value in stream.```
  fun helper(
      prefix :: List<Number>, 
      suffix :: Stream<Option<Number>>,
      index :: Number) 
    -> Stream<Option<Number>>:
    
    cases (Option<Number>) lz-first(suffix):
      | none => repeating-stream([list: none])
      | some(init-value) =>
        # WHEAT DIFFERENCE: If illegal value reached, returns stream of zeroes.
        ask:
          | (init-value < 0) and (index > 0) then: raise("Invalid coefficient")
          | (init-value == 0) and (index > 0) then: repeating-stream-opt([list: 0])
          | not(num-is-integer(init-value)) then: raise("Coefficients must be integers.")
          | otherwise:
            value =
              for fold(value from init-value, item from prefix):
                item + (1 / value)
              end
            lz-link(
              some(value), 
              {(): helper(prefix.push(init-value), lz-rest(suffix), index + 1)})
        end
    end
  end

  helper(empty, stream, 0)
end

fun fraction-stream(stream :: Stream<Number>) -> Stream<Number>:
  doc: "Creates a stream of fractions from a given contfrac stream."
  lz-map({(opt-value :: Option<Number>) -> Number: 
      cases (Option<Number>) opt-value:
        | none => raise("Shouldn't reach here.")
        | some(value) => value
      end},
    fraction-stream-opt(lz-map(some, stream)))
end

# threshold

fun threshold-opt(stream :: Stream<Option<Number>>, max :: Number) -> Number:
  doc: "Returns the first value in stream within max of next value."
  cases (Option<Number>) lz-first(stream):
    | none => raise("Threshold too small to approximate")
    | some(first) =>
      cases (Option<Number>) lz-first(lz-rest(stream)):
        | none => raise("Threshold too small to approximate")
        | some(second) =>
          if num-abs(first - second) < max:
            first
          else:
            threshold-opt(lz-rest(stream), max)
          end
      end
  end
end

fun threshold(stream :: Stream<Number>, max :: Number) -> Number:
  doc: "Returns the first value in stream within max of next value."
  threshold-opt(lz-map(some, stream), max)
end


#|
   Hard-coded ContFracs
|#

rec cf-phi :: Stream<Number> = lz-link(1, {(): cf-phi})
cf-phi-opt :: Stream<Option<Number>> = lz-map(some, cf-phi)

fun make-e(n :: Number) -> Stream<Number>:
  lz-link(1, {(): lz-link(1, {(): lz-link(n, {(): make-e(n + 2)})})})
end
cf-e :: Stream<Number> = lz-link(2, {(): lz-rest(make-e(2))})
cf-e-opt :: Stream<Option<Number>> = lz-map(some, cf-e)

# WHEAT DIFFERENCE: Pi defined to many coefficients. http://oeis.org/A001203
cf-pi-opt :: Stream<Option<Number>> = terminating-stream(
  [list: 
    3, 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2, 1, 84, 2, 1, 1, 15, 3, 13,
    1, 4, 2, 6, 6, 99, 1, 2, 2, 6, 3, 5, 1, 1, 6, 8, 1, 7, 1, 2, 3, 7, 1, 2, 1, 1, 12, 1, 1, 1,
    3, 1, 1, 8, 1, 1, 2, 1, 6, 1, 1, 5, 2, 2, 3, 1, 2, 4, 4, 16, 1, 161, 45, 1, 22, 1, 2, 2, 1,
    4, 1, 2, 24, 1, 2, 1, 3, 1, 2, 1])

