# CSCI0190 (Fall 2020)

include cpo

provide {is-valid: is-valid, generate-input: generate-input, oracle: oracle} end

import my-gdrive("sortacle-common.arr") as common

type Person = common.Person
person = common.person
is-person = common.is-person
is-Person = common.is-Person

#| chaff (tdelvecc, Sep 6, 2020): 
    generate-input makes negative ages sometimes.
    Search "CHAFF DIFFERENCE" for changed code.
|#

fun generate-input(n :: Number) -> List<Person> block:
  doc: "Generates n random Persons."
  
  when n < 0:
    raise("Invalid n provided.")
  end
  
  fun generate-name(length :: Number) -> String:
    doc: "Generates a random name of given length."
    for lists.map(_ from range(0, length)):
      num-random(65535)
    end
      ^ string-from-code-points
  end
  
  for lists.map(_ from range(0, n)):
    person(
      generate-name(num-random(100)),
      # CHAFF DIFFERENCE: Half of ages are negative.
      num-random(1e6) - 5e5)
  end
end


fun generate-input-good(n :: Number) -> List<Person> block:
  doc: "Generates n random Persons."
  
  when n < 0:
    raise("Invalid n provided.")
  end
  
  fun generate-name(length :: Number) -> String:
    doc: "Generates a random name of given length."
    for lists.map(_ from range(0, length)):
      num-random(65535)
    end
      ^ string-from-code-points
  end
  
  for lists.map(_ from range(0, n)):
    person(
      generate-name(num-random(100)),
      num-random(1e6) + 1e6)
  end
end

fun sort-uniquely(lst :: List<Person>) -> List<Person>:
  doc: "Sorts the given list of people so that therer is only one correct order."
  lst.sort-by(
    {(p1 :: Person, p2 :: Person): 
      (p1.age < p2.age) or ((p1.age == p2.age) and (p1.name < p2.name))},
    {(p1 :: Person, p2 :: Person): p1 == p2})
end

fun is-valid(input :: List<Person>, output :: List<Person>) -> Boolean:
  doc: "Checks whether output is a valid sorting of input."
  # The output contains all of the same elements as the input
  (sort-uniquely(input) == sort-uniquely(output)) and
  # and the output is in increasing age order.
  cases (List<Person>) output:
    | empty => true
    | link(_, r) =>
      for lists.all2(left :: Person from output, right from r):
        left.age <= right.age
      end
  end
end


fun oracle(sorter :: (List<Person> -> List<Person>)) -> Boolean:
  doc: "Checks whether sorter is a valid sorter."
  interesting-inputs :: List<List<Person>> = [list:
    [list: ], # empty
    [list: person("A Person", 0)], # one person
    [list: person("A Person", 10), person("B Person", 10)], # two person 1
    [list: person("A Person", 10), person("B Person", 20)], # two person 2
    [list: person("A Person", 20), person("B Person", 10)], # two person 3

    # repeated person
    lists.repeat(20, person("A Person", 5)),
    
    # same name, diff age
    range(0, 10).map(person("A Person", _)), 
    
    # repeat ages, so many valid sorts
    range(0, 100).map({(n): 
        person(
          [list: "A", "B", "C"].get(num-modulo(n, 3)), 
          num-modulo(n, 4))}),
    
    # same age, diff name
    generate-input-good(10).map({(p): person(p.name, 10)}),
    
    # old people
    generate-input-good(15).map({(p): person(p.name, p.age + 100000000)}),
    
    # one of a, two of b (in case something with list equivalence is messed up)
    [list: person("a", 20), person("b", 10), person("a", 20)],
    
    # long and reverse sorted
    lists.map2({(p, age): person(p.name, age)}, generate-input-good(150), range(0, 150))
      .reverse()
  ]
  
  # Manual inputs
  for lists.all(input from interesting-inputs):
    is-valid(input, sorter(input))
  end
  and 
  # Automated inputs
  for lists.all(n from range(3, 30)):
    input = generate-input-good(n)
    is-valid(input, sorter(input))
  end
end

