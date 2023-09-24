provide *
provide-types *

include cpo

include file("nile-common.arr")
include file("nile-support.arr")

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in this file.

fun recommend(title :: String, book-records :: List<File>) 
  -> Recommendation<String>:
  doc: ```Takes in the title of a book and a list of files,
       and returns a recommendation of book(s) to be paired with title
       based on the files in book-records.```
  ...
end

fun popular-pairs(records :: List<File>) -> Recommendation<BookPair>:
  doc: ```Takes in a list of files and returns a recommendation of
       the most popular pair(s) of books in records.```
  ...
end
