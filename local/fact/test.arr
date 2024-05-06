include cpo

include file("fact-code.arr")
include file("fact-qtm.arr")

check:
  fact(1) is 1
  1 satisfies fact-in-ok
  -2 violates fact-in-ok
  40 satisfies fact-in-ok
  fact(2) is 2
  fact(3) is 6
end
