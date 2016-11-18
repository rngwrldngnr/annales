module Annales.Empire (
  Empire
  ,TextGenCh
  ,Person(..)
  ,Forebear(..)
  ,emperor
  ,court
  ,tribes
  ,lineage
  ,pGen
  ,pAge
  ,vocabGet
  ,initialiseEmpire
  ,incrementYear
  ,agePerson
  ,yearDesc
  ,generate
  ,dumbjoin
  ,wordjoin
  ,cap
  ,phrase
  ,randn
  ,chooseW
  ,showL
  ) where


import TextGen (
  TextGen
  ,runTextGen
  ,word
  ,choose
  ,remove
  ,list
  ,randrep
  ,rep
  ,perhaps
  ,smartjoin
  ,loadOptions
  )

import Data.Map (Map)
import Data.List (intercalate)
import Data.Char (toUpper)
import qualified Data.Map as Map
import System.Directory (getDirectoryContents)
import Text.Regex.Posix
import System.Random (StdGen, getStdRandom, randomR)



type TextGenCh = TextGen StdGen [[Char]]

data Forebear = Forebear [ Char ] (Maybe Int)
  deriving Show

data Person = Person TextGenCh Int

data Empire = Empire { emperor :: Person
                     , lineage :: [ Forebear ]
                     , court :: [ TextGenCh ]
                     , tribes :: [ TextGenCh ]
                     , projects :: [ TextGenCh ]
                     , vocab :: Map String TextGenCh
                     }


pGen :: Person -> TextGenCh
pGen (Person t _) = t

pAge :: Person -> Int
pAge (Person _ a) = a

agePerson :: Person -> Person
agePerson p = (Person (pGen p) ((pAge p) + 1)) 

nullGen :: TextGenCh
nullGen = word "-"

generate g = getStdRandom $ runTextGen g

chooseW :: [ [ Char ] ] -> TextGenCh
chooseW l = choose (map word l)

dumbjoin :: [ [ Char ] ] -> [ Char ]
dumbjoin s = intercalate " " s

cap :: [ Char ] -> [ Char ]
cap [] = []
cap (x:xs) = (toUpper x):xs 

wordjoin :: [ [ Char ] ] -> TextGenCh
wordjoin = word . dumbjoin

phrase :: TextGenCh -> TextGenCh
phrase g = list [ comma, g, comma ]
  where comma = word ","

randn :: Int -> IO Int
randn n = do
  r <- getStdRandom $ randomR ( 0, n - 1 )
  return r

showL :: [ TextGenCh ] -> IO [ Char ]
showL []     = return ""
showL (g:gs) = do
  gt <- generate g
  gtr <- showL gs
  return $ (smartjoin gt) ++ ", " ++ gtr





vocabGet :: Empire -> String -> TextGenCh
vocabGet e name = case Map.lookup (name ++ ".txt") (vocab e) of
  Nothing -> nullGen
  Just gen -> gen


isTextFile :: String -> Bool
isTextFile f = f =~ ".txt$"


loadVocab :: String -> IO ( Map String TextGenCh )
loadVocab dir = do
  files <- getDirectoryContents dir
  list <- mapM loadFile $ filter isTextFile files
  return $ Map.fromList list
    where loadFile f = do
            gen <- loadOptions ( dir ++ f )
            return ( f, gen )
  
sampleVocab :: Map String TextGenCh -> String -> IO ( [ Char ] )
sampleVocab vocab name = do
  mgen <- return $ Map.lookup name vocab
  case mgen of
    (Just gen) -> do
      genc <- generate gen
      return $ dumbjoin genc
    Nothing -> return ( "Vocab file not found: " ++ name )

initialE = Empire { emperor = Person (word "") 0
                  , lineage = []
                  , court = []
                  , tribes =  []
                  , projects = []
                  , vocab = Map.empty
                  }


incrementYear :: Empire -> Empire
incrementYear e = e { emperor = (agePerson (emperor e)) } 

yearDesc :: Empire -> TextGenCh
yearDesc e = let a = word $ show $ pAge $ emperor e
                 g = pGen $ emperor e
             in list [ word "Year", a, word "in the reign of", g ]

initialiseEmpire :: String -> IO ( Empire )
initialiseEmpire dir = do
  v <- loadVocab dir
  return $ initialE { vocab = v }
  
