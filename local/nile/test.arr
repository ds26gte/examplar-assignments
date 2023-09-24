# import student solution here
include cpo

import file("nile-code.arr") as sm
import file("nile-support.arr") as NT
type File = NT.File
file = NT.file
type Recommendation = NT.Recommendation
recommendation = NT.recommendation
type BookPair = NT.BookPair
pair = NT.pair
popular-pairs = sm.popular-pairs
recommend = sm.recommend

fun index-of(n :: String, ch :: String) -> Number:
  doc: "returns index of ch in n, returns length of n if ch not found"
  if string-equal(n, "") or string-equal(string-char-at(n,0), ch):
    0
  else:
    1 + index-of(string-substring(n, 1, string-length(n)), ch)
  end
end

fun same-rec(t1 :: Recommendation, t2 :: Recommendation) -> Boolean:
  t1 == t2
end

bl1=file("1",[list: "aa", "bb", "cc", "dd", "ee", "ff", "gg"])
bl2=file("2",[list: "aa", "bb"])
bl3=file("3",[list: "aa", "bb", "cc", "dd"])
bl4=file("4",[list: "ff", "dd", "ee"])
bl5=file("5",[list: "bb", "aa"])

recommend
check "normal-recommend:: Normal operational conditions for recommend":
  # recommend on a file with two elements when one 
  # is the input should return a recommendation for the other
  same-rec(recommend("aa",[list: bl2]),recommendation(1,[list: "bb"])) is true

  # recommend when there are multiple other books on the 
  # file should return a recommendation with those others
  same-rec(recommend("dd",[list: bl4]),recommendation(1,[list: "ff","ee"]))
    is true

  # recommend on two files when one element is in
  # both files should return that element
  same-rec(recommend("aa",[list: bl3,bl2]),recommendation(2,[list: "bb"]))
    is true

  # recommend on three files when one element is in
  # all three should return that element
  same-rec(recommend("aa",[list: bl5,bl2,bl2]),recommendation(3,[list: "bb"]))
    is true

  # recommend on multiple files when one file does not have the input 
  # should just return the closest recommendation from files with that input
  same-rec(recommend("aa",[list: bl2,bl4]),recommendation(1,[list: "bb"]))
    is true
end

check ```no-recommend-match:: Confirms recommend can handle a call where
    the title is not in an input file```:
  # recommend on a file where the inputted element does not exist 
  # should return an empty recommendation
  same-rec(recommend("cc",[list: bl2]),recommendation(0,empty)) is true
end

#popular-pairs
check "normal-popular-pairs:: Normal operational conditions for recommend":
  # popular-pairs when only one file is given
  same-rec(popular-pairs([list: bl4]), 
      recommendation(1, [list: pair("ff","dd"), pair("ee","ff"), pair("dd","ee")])) is true

  # simple popular-pairs with one pair represented on both files
  same-rec(popular-pairs([list: bl1,bl2]),
      recommendation(2,[list: pair("bb","aa")])) is true

  # popular-pairs between two files where three pairs are represented on both
  same-rec(popular-pairs([list: bl4,bl1]),
      recommendation(2,[list: pair("ff","dd"),pair("ee","ff"),pair("dd","ee")])) is true

  # popular-pairs with duplicates of one file that 
  # has one pair of books repreated four times
  same-rec(popular-pairs([list: bl2,bl2,bl1,bl2]),
      recommendation(4,[list: pair("aa","bb")])) is true

  # popular-pairs with five files should successfully generate the most 
  # popular pair (in this case repeated four times)
  same-rec(popular-pairs([list: bl1,bl2,bl3,bl4,bl5]),
      recommendation(4,[list: pair("bb","aa")])) is true
end

check ```no-pair-overlap:: Confirms popular-pairs can
      handle files with no overlap```:
  # popular-pairs when there is no overlap between book files
  same-rec(popular-pairs([list: bl2,bl4]),
      recommendation(1,[list: pair("bb","aa"), pair("ff","dd"), pair("dd","ee"), pair("ee","ff")])) is true
end

#both
check "empty:: Confirms functions handle empty inputs":
  # recommend with no files returns an empty recommendation
  same-rec(recommend("aa",empty),recommendation(0,empty)) is true

  # popular-pairs when no files are given return empty recommendations
  same-rec(popular-pairs(empty), recommendation(0, empty)) is true
end
