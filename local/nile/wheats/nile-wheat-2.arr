# CSCI0190 (Fall 2020)
include cpo
import lists as lysts



provide {recommend: recommend, popular-pairs: popular-pairs} end

#| wheat (tdelvecc, Aug 26, 2020): 
    Flips the order of the contents list in the resulting recommendation.
    Flips the order of books in book pairs.
    Raises error on invalid inputs:
     - contents list doesn't contain at least two books
     - contents list contains duplicate books
     - a book title is the empty string
    Search "WHEAT DIFFERENCE" for changed code.
|#

include file("../nile-support.arr")

fun get-all-books(records :: List<File>) -> List<String> block:
  doc: ```Gets all of the books out of a list of records.```
  # WHEAT DIFFERENCE: Raises an error if any contents lists are too small.
  when records.any({(f): f.content.length() < 2}):
    raise("Contents list too small.")
  end
  
  # WHEAT DIFFERENCE: Raises an error if any contents lists contain duplicates.
  when records.any({(f): f.content.length() <> lysts.distinct(f.content).length()}):
    raise("Contents contains duplicate.")
  end
  
  # WHEAT DIFFERNECE: Raises an error if any title is the empty string.
  when records.any({(f): f.content.member("")}):
    raise("Empty title!")
  end
  
  records
    .map(_.content)
    .foldl(lysts.append, empty)
end

fun gather-recos<A>(recos :: List<Recommendation<A>>) -> Recommendation<A>:
  doc: ```Takes a list of recommendation and combines the largest ones
       into a single recommendation.```
  for lysts.foldl(
      best-reco :: Recommendation<A> from recommendation(0, empty),
      book-reco :: Recommendation<A> from recos):
    ask:
        # If one reco is better than the other, then take that one.
      | book-reco.count > best-reco.count then: book-reco
      | book-reco.count < best-reco.count then: best-reco
        # If both recos have 0 count, then keep book list empty
      | (book-reco.count == 0) and (best-reco.count == 0) then: best-reco
      | book-reco.count == best-reco.count then: 
        # Take the total-reco and add the contents of book-reco, except duplicates.
        recommendation(best-reco.count, lysts.distinct(best-reco.content + book-reco.content))
    end
  end
  # WHEAT DIFFERENCE: Reverses the order of contents in the recommendation.
    ^ {(reco :: Recommendation<A>): recommendation(reco.count, reco.content.reverse())}
end

fun recommend(title :: String, book-records :: List<File>) 
  -> Recommendation<String> block:
  doc: ```Takes in the title of a book and a list of files,
       and returns a recommendation of book(s) to be paired with title
       based on the files in book-records.```
  # WHEAT DIFFERENCE: Raises error if given book title was empty string.
  when title == "":
    raise("Empty book title given!")
  end
  
  book-records
    ^ get-all-books
    ^ filter(_ <> title, _) # Duplicates are ok since gather-recos will handle them
    ^ map({(book): # Create individual recommendations for each book
      recommendation(
        book-records
        # Find number of records with both book and title
          .filter({(record): record.content.member(book)})
          .filter({(record): record.content.member(title)})
          .length(),
        [list: book])}, _)
    ^ gather-recos
end

fun popular-pairs(book-records :: List<File>) -> Recommendation<BookPair>:
  doc: ```Takes in a list of files and returns a recommendation of
       the most popular pair(s) of books in records.```
  book-records
    ^ get-all-books
    ^ map({(book): # Create individual pair recommendations for each book
      reco = recommend(book, book-records)
      # WHEAT DIFFERENCE: Reverses the order of pairs.
      recommendation(reco.count, reco.content.map(pair(book, _)))}, _)
    ^ gather-recos
end
