module Main where

import qualified Data.Map as M

allOddVals :: M.Map Char Int -> Bool
allOddVals charCounts = M.foldr (&&) True (M.map odd charCounts)
  
allEvenVals :: M.Map Char Int -> Bool
allEvenVals charCounts = M.foldr (&&) True (M.map even charCounts)

numDistinctCharacters :: M.Map Char Int -> Int
numDistinctCharacters charCounts = M.size $ M.filter (> 0) charCounts

differentCharacters :: String -> M.Map Char Int
differentCharacters string = M.fromListWith (+) $ [('a', 0), ('b', 0), ('c', 0)]++[(char, 1) | char <- string]
      
shortestReplace :: String -> Int
shortestReplace string =
  let charCounts = differentCharacters string
      numChars = length string
  in if 1 >= numDistinctCharacters charCounts
  then numChars
  else if allEvenVals charCounts || allOddVals charCounts
  then 2
  else 1
  
main ::IO ()
main = interact processInteract
processInteract input = 
  let stdin = (lines input)
      numcases = read (head stdin)::Int
  in unlines [show (shortestReplace line) | line <- take numcases (tail stdin)]
