####### Section 1: Variable Definitions ###############
include cpo

include file("is-on-screen-code.arr")



####### Section 2: Commutative Property Examples #####

examples: 
  
  is-on-screen(9000) is false
  is-on-screen(-50) is false
  is-on-screen(200) is true
  is-on-screen(690) is false
  is-on-screen(-9000) is false
  is-on-screen(-40) is true
  is-on-screen(680) is true
  
end



