include cpo
include file("wheats/docdiff-wheat.arr")

# Plan Outline:
# Count instances of each unique word 
# Make each unique word's count a component of the vector 
# Normalize both vectors to cover length distances
# Find dot product of two vectors
# Divide dot product by product of magnitudes

test_doc1 = [list:"John", "likes", "to", "watch", "movies", "Mary", "likes", "to", "too"]
test_doc2 = [list:"John", "also", "likes", "to", "watch", "football", "games"]
test_doc3 = [list:"Third", "in", "testing", "series", "watch", "it", "overlap", "with", "allofthem.", "football", "common"]
doc-different = [list:"nothing", "in", "common", "with", "either", "one"]
cats = [list:"The", "cat", "the", "cat"]
dogs = [list:"The", "dog", "the", "dog"]
the = [list: "the"]
the-2 = [list: "the", "the"]
empty-5 = [list: "", "", "", "", ""]
empty-2 = [list: "", ""]


check "different:: Completely different documents":
  overlap(test_doc1, doc-different) is%(within(0.000000000001)) 0
  overlap(test_doc2, doc-different) is%(within(0.000000000001)) 0
end

check "identical documents":
  overlap(test_doc1, test_doc1) is%(within(0.000000000001)) 1
  overlap(test_doc2, test_doc2) is%(within(0.000000000001)) 1
end

check "capitalization:: Ignores capitalization":
  ## if they fail either of these, its probably an issue with not to-lower or to-upper'ing all their words
  overlap(cats, dogs) is%(within(0.000000000001)) 1/2
  overlap(dogs, cats) is%(within(0.000000000001)) 1/2
end

### Below here are "normal cases" ###

check "symmetry":
  one-way = overlap(test_doc1, test_doc2)
  overlap(test_doc2, test_doc1) is%(within(0.000000000001)) one-way
end

check "duplicates:: Deals with duplicates properly":
  #failing here probably means an issue dealing with duplicates
  overlap(the-2, the) is%(within(0.000000000001)) 1/2
  overlap(the-2 + the, the) is%(within(0.000000000001)) 1/3
end

check "normal:: Normal cases":
  overlap(test_doc1, test_doc2) is%(within(0.000000000001)) (6/13)
  overlap(test_doc2, test_doc1) is%(within(0.000000000001)) (6/13)
  overlap(test_doc1, test_doc3) is%(within(0.000000000001)) (1/13)
  overlap(test_doc2, test_doc3) is%(within(0.000000000001)) (2/11)
  overlap(doc-different, test_doc3) is%(within(0.000000000001)) (3/11)
  overlap(empty-5, empty-2) is 2/5
end
