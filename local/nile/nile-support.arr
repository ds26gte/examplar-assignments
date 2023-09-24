include cpo

import equality as E

provide:
  *,
  type *,
  data *
end

data File:
  | file(name :: String, content :: List<String>)
end

data BookPair:
  | pair(book1 :: String, book2 :: String)
    with:
    method _equals(
        self :: BookPair,
        other :: BookPair,
        equal-rec :: (Any, Any -> E.EqualityResult))
      -> E.EqualityResult:
      cases (BookPair) self:
        | pair(sb1, sb2) =>
          cases (BookPair) other:
            | pair(ob1, ob2) =>
              if ((E.is-Equal(equal-rec(sb1, ob1)) 
                    and E.is-Equal(equal-rec(sb2, ob2))) or
                  (E.is-Equal(equal-rec(sb1, ob2)) 
                    and E.is-Equal(equal-rec(sb2, ob1)))):
                E.Equal
              else:
                E.NotEqual("different books", self, other)
              end
          end
      end
    end
    #|where:
  pair("a", "b") is pair("b", "a")
  pair("a", "b") is pair("a", "b")
  pair("a", "b") is-not pair("a", "B")|#
end


data Recommendation<A>:
  | recommendation(count :: Number, content :: List<A>)
    with:
    method _equals(
        self :: Recommendation<A>,
        other :: Recommendation<A>, 
        equal-rec :: (Any, Any -> E.EqualityResult))
      -> E.EqualityResult:

      fun names-to-set(names :: List<A>) -> Set<A>:
        list-to-list-set(names)
      end
      cases (Recommendation<A>) self:
        | recommendation(sc, scont) =>
          cases (Recommendation<A>) other:
            | recommendation(oc, ocont) =>
              if self.count <> other.count:
                E.NotEqual("inequal counts", self.count, other.count)
              else if not(self.content.length() == other.content.length()):
                E.NotEqual("inequal content length", 
                  self.content.length(), other.content.length())
              else:
                equal-rec(
                  names-to-set(self.content),
                  names-to-set(other.content))
              end
          end
      end
    end
    #|where:
  # counts must be equal
  recommendation(1, empty) is recommendation(1, empty)
  recommendation(1, empty) is-not recommendation(2, empty)

  # order of names list doesn't matter
  recommendation(1, [list: 'a', 'b']) 
    is recommendation(1,  [list: 'b', 'a'])

  # this equality definition means that duplicates aren't allowed
  recommendation(1, [list: pair('a','b'), pair('a','b')])
    is-not recommendation(1, [list: pair('b','a')])|#

end
