# CSCI0190 (Fall 2018)

# Use this to run a wheat, but FYI it does not type-check 
# import shared-gdrive("contfrac-wheat-overly-excitable.arr", "1ijPk_1QJ77TpBDx45e1Z2vEeaQbC_BNt") as student

include cpo

import file("contfracs-code.arr") as student
include file("contfracs-types.arr")
  
import lists as L

take = student.take
cf-phi = student.cf-phi
cf-e = student.cf-e
repeating-stream = student.repeating-stream
threshold = student.threshold
fraction-stream = student.fraction-stream
cf-phi-opt = student.cf-phi-opt
cf-e-opt = student.cf-e-opt
cf-pi-opt = student.cf-pi-opt
terminating-stream = student.terminating-stream
repeating-stream-opt = student.repeating-stream-opt
threshold-opt = student.threshold-opt
fraction-stream-opt = student.fraction-stream-opt


## IMPORTANT (zespirit): I wrote this test suite on a long winter night and
## long story short I accidentally flipped the parameters of the take function
## so instead of flipping the parameters again, I just wrote a wrapper function
## that redefines take such that the parameters are flipped. (sorry if this
## causes any confusion)

## 9/5/2020: On a sunny, bright afternoon Leila and Raj undid the fake_take 
## and restored everything to its natural order to pass the type-checker.


## Part 1: Streams

check "take returns empty list when asked for zero elements":
  rec a-stream = lz-link(1, lam(): a-stream end)
  L.length(take(a-stream, 0)) is 0
end

check "take returns list containing correct number of non-zero elements":
  rec a-stream = lz-link(1, lam(): a-stream end)
  L.length(take(a-stream, 1)) is 1
  L.length(take(a-stream, 3)) is 3
  L.length(take(a-stream, 5)) is 5
  L.length(take(a-stream, 10)) is 10
end


# cf-phi:

check "cf-phi has expected terms of 1, repeating":
  # Check the first 10000 terms of cf-phi:
  is-repeating-partial-sequence(cf-phi, [list: 1], 10000) is true
end


# cf-e:

check "cf-e has a first term of value 2":
  lz-first(cf-e) is 2
end

check ```cf-e, after the first term, has partial sequences of length 3 where the
      first and last elements in the sequence are 1 and the middle element is 2n,
      where n is the number of partial sequences traversed thus far```:
  # We use lz-rest to skip the first term in cf-e, because there's a separate 
  # check for that (see above). Check the next 9000 terms:
  cf-e-checker(lz-rest(cf-e), 0, 3000, false) is true
end


# repeating-stream:

check ```repeating-stream returns a Stream of repeating values for an input List 
      of length 1```:
  # Check the first 10000 terms of neg-ones:
  neg-ones = repeating-stream([list: -1])
  is-repeating-partial-sequence(neg-ones, [list: -1], 10000) is true

  # Check the first 10000 terms of zeroes:
  zeroes = repeating-stream([list: 0])
  is-repeating-partial-sequence(zeroes, [list: 0], 10000) is true

  # Check the first 10000 terms of ones:
  ones = repeating-stream([list: 1])
  is-repeating-partial-sequence(ones, [list: 1], 10000) is true

  # Check the first 10000 terms of twos:
  twos2 = repeating-stream([list: 2])
  is-repeating-partial-sequence(twos2, [list: 2], 10000) is true
end

check ```repeating-stream returns a Stream of repeating values for an input List 
      of length greater than 1```:
  # Check the first 10000 terms of doubles:
  doubles = repeating-stream([list: 1, 2])
  is-repeating-partial-sequence(doubles, [list: 1, 2], 5000) is true

  # Check the first 9000 terms of triples:
  triples = repeating-stream([list: 1, 2, 3])
  is-repeating-partial-sequence(triples, [list: 1, 2, 3], 3000) is true

  # Check the first 10000 terms of randoms:
  partial-sequence =
    [list: 
      num-random(100), 
      num-random(100), 
      num-random(100), 
      num-random(100), 
      num-random(100)]
  randoms = repeating-stream(partial-sequence)
  is-repeating-partial-sequence(randoms, partial-sequence, 2000) is true
end


# threshold:

check ```threshold outputs the correct threshold for a given input Stream of
      coefficients```:
  sample-approximations = fraction-stream(repeating-stream([list: 1, 2, 3]))

  approximation-a = lz-first(lz-rest(lz-rest(sample-approximations)))
  approximation-b = lz-first(lz-rest(lz-rest(lz-rest(sample-approximations))))

  # Sanity check:
  approximation-a is-roughly ~1.428571
  approximation-b is-roughly ~1.444444
  num-abs(approximation-a - approximation-b) < 0.03 is true

  # Actual test:
  threshold(sample-approximations, 0.03) is approximation-a
end

check ```threshold outputs the correct threshold for a given input Stream of
      coefficients where all of the coefficients are the same value```:
  sample-approximations-1 = fraction-stream(repeating-stream([list: 1]))
  threshold(sample-approximations-1, 0.10) is-roughly ~1.666666
  threshold(sample-approximations-1, 0.03) is 1.6
  threshold(sample-approximations-1, 0.01) is 1.625
  threshold(sample-approximations-1, 0.0001) is-roughly ~1.617977

  sample-approximations-2 = fraction-stream(repeating-stream([list: 2]))
  threshold(sample-approximations-2, 0.10) is 2.4
  threshold(sample-approximations-2, 0.03) is 2.4
  threshold(sample-approximations-2, 0.01) is-roughly ~2.416666
  threshold(sample-approximations-2, 0.0001) is-roughly ~2.414285

  sample-approximations-5 = fraction-stream(repeating-stream([list: 5]))
  threshold(sample-approximations-5, 0.10) is 5.2
  threshold(sample-approximations-5, 0.03) is 5.2
  threshold(sample-approximations-5, 0.01) is 5.2
  threshold(sample-approximations-5, 0.0001) is-roughly ~5.192592
end


# fraction-stream:

check "fraction-stream calculates correct approximations for randomly generated streams":
  for each(_ from range(0, 10)): # run test against 10 randomly generated streams
    a = num-random(100) + 1
    b = num-random(100) + 1
    c = num-random(100) + 1
    d = num-random(100) + 1
    e = num-random(100) + 1
    partial-sequence = [list: a, b, c, d, e]

    take(fraction-stream(repeating-stream(partial-sequence)), 5)
      is [list:
      a,
      a + (1 / b),
      a + (1 / (b + (1 / c))),
      a + (1 / (b + (1 / (c + (1 / d))))),
      a + (1 / (b + (1 / (c + (1 / (d + (1 / e)))))))]
  end
end

check "fraction-stream calculates correct approximations for cf-phi":
  take(fraction-stream(cf-phi), 5)
    is [list:
    1,
    1 + (1 / 1),
    1 + (1 / (1 + (1 / 1))),
    1 + (1 / (1 + (1 / (1 + (1 / 1))))),
    1 + (1 / (1 + (1 / (1 + (1 / (1 + (1 / 1)))))))]
end

check "fraction-stream calculates correct approximations for cf-e":
  take(fraction-stream(cf-e), 5)
    is [list:
    2,
    2 + (1 / 1),
    2 + (1 / (1 + (1 / 2))),
    2 + (1 / (1 + (1 / (2 + (1 / 1))))),
    2 + (1 / (1 + (1 / (2 + (1 / (1 + (1 / 1)))))))]
end


## Part 2: Options and Terminating Streams

# cf-phi-opt:

check "cf-phi-opt has expected terms of some(1), repeating":
  # Check the first 10000 terms of cf-phi-opt:
  is-repeating-partial-sequence(cf-phi-opt, [list: some(1)], 10000) is true
end


# cf-e-opt:

check "cf-e-opt has a first term of value some(2)":
  lz-first(cf-e-opt) is some(2)
end

check ```cf-e-opt, after the first term, has partial sequences of length 3 where 
      the first and last elements in the sequence are some(1) and the middle element 
      is some(2n), where n is the number of partial sequences traversed thus far```:
  # We use lz-rest to skip the first term in cf-e, because there's a separate 
  # check for that (see above). Check the next 900 terms:
  cf-e-checker(lz-rest(cf-e-opt), 0, 300, true) is true
end


# cf-pi-opt:

check "cf-pi-opt's first five terms have correct values":
  take(cf-pi-opt, 5)
    is [list: some(3), some(7), some(15), some(1), some(292)]
end

check "cf-pi-opt's first six terms have correct values if there are at least six":
  first-six = take(cf-pi-opt, 6)
  all-are-some = first-six.foldl(lam(elt, acc): is-some(elt) and acc end, true)
  
  if all-are-some:
    first-six is [list: some(3), some(7), some(15), some(1), some(292), some(1)]
  else:
    first-six is [list: some(3), some(7), some(15), some(1), some(292), none]
  end
end


# terminating-stream:

check ```terminating-stream returns a Stream where all the terms are `none` if the
      input list is empty```:
  # Check the first 100 terms:
  is-repeating-partial-sequence(
      terminating-stream(empty), [list: none], 100) is true
end

check ```terminating-stream returns a Stream where all terms but the first are 
      `none` if the input list is of length 1```:
  # Check the first term is correct:
  all-but-one-stream = terminating-stream([list: 1])
  lz-first(all-but-one-stream) is some(1)

  # Check the next 100 terms after the first term:
  none-stream = lz-rest(all-but-one-stream)
  is-repeating-partial-sequence(none-stream, [list: none], 100) is true

  # Check the first term is correct:
  all-but-two-stream = terminating-stream([list: 2])
  lz-first(all-but-two-stream) is some(2)

  # Check the next 100 terms after the first term:
  none-two-stream = lz-rest(all-but-two-stream)
  is-repeating-partial-sequence(none-two-stream, [list: none], 100) is true
end

check ```terminating-stream returns a Stream where all terms but the first are 
      `none` if the input lists are greater than length 1```:
  # Check that each input list appears at the beginning of the stream:
  input-list   = [list: 1, 2, 3, 4, 5]
  term-stream  = terminating-stream(input-list)
  input-length = L.length(input-list)
  take(term-stream, input-length) 
    is [list: some(1), some(2), some(3), some(4), some(5)]

  # Check that the next 100 terms after the appearance of the input-list are
  # all none:
  remaining-stream = drop(input-length, term-stream)
  is-repeating-partial-sequence(remaining-stream, [list: none], 100) is true
end


# repeating-stream-opt:

check ```repeating-stream-opt returns a Stream of repeating values for an input 
      List of length 1```:
  # Check the first 100 terms of neg-ones:
  neg-ones = repeating-stream-opt([list: -1])
  is-repeating-partial-sequence(neg-ones, [list: some(-1)], 100) is true

  # Check the first 100 terms of zeroes:
  zeroes = repeating-stream-opt([list: 0])
  is-repeating-partial-sequence(zeroes, [list: some(0)], 100) is true

  # Check the first 100 terms of ones:
  ones = repeating-stream-opt([list: 1])
  is-repeating-partial-sequence(ones, [list: some(1)], 100) is true

  # Check the first 100 terms of twos:
  twos2 = repeating-stream-opt([list: 2])
  is-repeating-partial-sequence(twos2, [list: some(2)], 100) is true
end

check ```repeating-stream-opt returns a Stream of repeating values for an input 
      List of length greater than 1```:
  # Check the first 500 terms of doubles:
  doubles = repeating-stream-opt([list: 1, 2])
  is-repeating-partial-sequence(
    doubles, [list: some(1), some(2)], 500) is true

  # Check the first 900 terms of triples:
  triples = repeating-stream-opt([list: 1, 2, 3])
  is-repeating-partial-sequence(
    triples, [list: some(1), some(2), some(3)], 300) is true

  # Check the first 500 terms of fivers:
  fivers = repeating-stream-opt([list: 9, 7, 5, 3, 1])
  is-repeating-partial-sequence(
    fivers, [list: some(9), some(7), some(5), some(3), some(1)], 500) is true
end


# threshold-opt:

check ```threshold-opt outputs the correct threshold for a given input Stream of
      coefficients from fraction-stream-opt```:
  sample-approximations = 
    fraction-stream-opt(repeating-stream-opt([list: 1, 2, 3]))

  approximation-a = lz-first(lz-rest(lz-rest(sample-approximations)))
  approximation-b = lz-first(lz-rest(lz-rest(lz-rest(sample-approximations))))

  # Sanity check:
  approximation-a is-roughly some(~1.428571)
  approximation-b is-roughly some(~1.444444)
  n1 = approximation-a.or-else(-1000)
  n2 = approximation-b.or-else(-2000)
  num-abs(n1 - n2) < 0.03 is true

  # num-abs(approximation-a.value - approximation-b.value) < 0.03 is true

  # Actual test:
  threshold-opt(sample-approximations, 0.03) is n1
end

check ```threshold-opt outputs the correct threshold for a given input Stream of
      coefficients from fraction-stream-opt where all of the coefficients are 
      the same value```:
  # Note that these tests are the same as the ones for `threshold`. If the
  # Stream has the same Option-al values as its corresponding non-Option Stream
  # does, we should get the same answer as long as the Stream never "ends" aka
  # has `none` elements.
  sample-approximations-1 = 
    fraction-stream-opt(repeating-stream-opt([list: 1]))
  threshold-opt(sample-approximations-1, 0.10) is-roughly ~1.666666
  threshold-opt(sample-approximations-1, 0.03) is 1.6
  threshold-opt(sample-approximations-1, 0.01) is 1.625
  threshold-opt(sample-approximations-1, 0.0001) is-roughly ~1.617977

  sample-approximations-2 = 
    fraction-stream-opt(repeating-stream-opt([list: 2]))
  threshold-opt(sample-approximations-2, 0.10) is 2.4
  threshold-opt(sample-approximations-2, 0.03) is 2.4
  threshold-opt(sample-approximations-2, 0.01) is-roughly ~2.416666
  threshold-opt(sample-approximations-2, 0.0001) is-roughly ~2.414285

  sample-approximations-5 = 
    fraction-stream-opt(repeating-stream-opt([list: 5]))
  threshold-opt(sample-approximations-5, 0.10) is 5.2
  threshold-opt(sample-approximations-5, 0.03) is 5.2
  threshold-opt(sample-approximations-5, 0.01) is 5.2
  threshold-opt(sample-approximations-5, 0.0001) is-roughly ~5.192592
end

check ```threshold-opt raises an error if the input Stream is comprised entirely of
      unknown approximations```:
  rec none-stream = lz-link(none, lam(): none-stream end)
  threshold-opt(none-stream, 1) raises "Threshold too small to approximate"
  threshold-opt(none-stream, 0.1) raises "Threshold too small to approximate"
  threshold-opt(none-stream, 0.01) raises "Threshold too small to approximate"
end

check ```threshold-opt raises an error if the input Stream only has one known 
      approximation```:
  one-stream = terminating-stream([list: 1])
  threshold-opt(one-stream, 1) raises "Threshold too small to approximate"
  threshold-opt(one-stream, 0.1) raises "Threshold too small to approximate"
  threshold-opt(one-stream, 0.01) raises "Threshold too small to approximate"
end

check ```threshold-opt raises an error if the given threshold cannot be met due to
      unknown approximations past a certain term```:
  terminating-approximations = 
    fraction-stream-opt(terminating-stream([list: 1, 2, 3, 4, 5]))
  threshold-opt(terminating-approximations, 0.00001)
    raises "Threshold too small to approximate"

  # See following check block for a sanity check to show that the given Stream has
  # valid thresh inputs that can be met.
end

check ```threshold-opt does not raise an error if the given threshold can be met
      before reaching the `none` terms in a terminating Stream of approximations```:
  terminating-approximations = 
    fraction-stream-opt(terminating-stream([list: 1, 2, 3, 4, 5]))

  threshold-opt(terminating-approximations, 1) is 1
  threshold-opt(terminating-approximations, 0.1) is 1.5
  threshold-opt(terminating-approximations, 0.01) is-roughly ~1.428571
end


# fraction-stream-opt:

check ```fraction-stream-opt calculates correct approximations for specified
      constants```:
  take(fraction-stream-opt(cf-phi-opt), 5)
    is [list:
    some(1),
    some(1 + (1 / 1)),
    some(1 + (1 / (1 + (1 / 1)))),
    some(1 + (1 / (1 + (1 / (1 + (1 / 1)))))),
    some(1 + (1 / (1 + (1 / (1 + (1 / (1 + (1 / 1))))))))]
  take(fraction-stream-opt(cf-e-opt), 5)
    is [list:
    some(2),
    some(2 + (1 / 1)),
    some(2 + (1 / (1 + (1 / 2)))),
    some(2 + (1 / (1 + (1 / (2 + (1 / 1)))))),
    some(2 + (1 / (1 + (1 / (2 + (1 / (1 + (1 / 1))))))))]
  take(fraction-stream-opt(cf-pi-opt), 5)
    is [list:
    some(3),
    some(3 + (1 / 7)),
    some(3 + (1 / (7 + (1 / 15)))),
    some(3 + (1 / (7 + (1 / (15 + (1 / 1)))))),
    some(3 + (1 / (7 + (1 / (15 + (1 / (1 + (1 / 292))))))))]
  
  # first coefficient can be negative
  beginning-negative = terminating-stream([list: -1, 2])
  take(fraction-stream-opt(beginning-negative), 2) is 
  [list: some(-1), some(-0.5)]
end

check ```fraction-stream-opt returns a Stream with none terms if the stream 
      eventually terminates```:
  # Check first 100 terms of none-frac-stream:
  none-frac-stream = fraction-stream-opt(terminating-stream(empty))
  is-repeating-partial-sequence(none-frac-stream, [list: none], 100) 
    is true

  # Check one-frac-stream has a defined first term:
  one-frac-stream = fraction-stream-opt(terminating-stream([list: 1]))
  lz-first(one-frac-stream) is some(1)
  # Check remaining 100 terms of one-frac-stream:
  is-repeating-partial-sequence(lz-rest(one-frac-stream), [list: none], 100) 
    is true
end

### Heler functions for testing

fun drop<T>(n :: Number, s :: Stream<T>) -> Stream<T>:
  doc: ```consumes a Stream<T> s and returns the Stream with the first n terms
       removed```

  if n == 0:
    s
  else:
    drop(n - 1, lz-rest(s))
  end
end

fun is-repeating-partial-sequence<T>(
    full-stream :: Stream<T>,
    partial-sequence :: List<T>%(is-link),
    times-to-recur :: Number) 
  -> Boolean:
  doc: ```iterates through each sequence of T elements in the given Stream<T> 
       full-stream and returns false if that partial sequence's List representation 
       does not match the given List<T> partial-sequence; otherwise, recurs on the
       next partial sequence times-to-recur```

  sequence-length = L.length(partial-sequence)
  stream-sequence = take(full-stream, sequence-length)

  if times-to-recur <= 0:
    true
  else if stream-sequence == partial-sequence:
    remaining-sequence = drop(sequence-length, full-stream)
    is-repeating-partial-sequence(
      remaining-sequence, 
      partial-sequence, 
      times-to-recur - 1)
  else:
    false
  end
end

fun cf-e-checker<T>(
    remaining-stream :: Stream<T>,
    times-iterated :: Number,
    remaining-iterations :: Number,
    use-option :: Boolean)
  -> Boolean:
  doc: ```used in tests for cf-e to check that the partial sequences of length
       3 past the first term have the correct values```

  partial-sequence = take(remaining-stream, 3)
  
  comparison-list = [list: 1, ((times-iterated + 1) * 2), 1]
  comparison-list-opt = [list: some(1), some((times-iterated + 1) * 2), some(1)]

  if remaining-iterations <= 0:
    true
  else if use-option and (partial-sequence == comparison-list-opt):
    cf-e-checker(
      drop(3, remaining-stream), 
      times-iterated + 1, 
      remaining-iterations - 1,
      use-option)
  else if not(use-option) and (partial-sequence == comparison-list):
    cf-e-checker(
      drop(3, remaining-stream), 
      times-iterated + 1, 
      remaining-iterations - 1,
      use-option)
  else:
    false
  end
end
