module Annales.Court (
  newCourtier
  ,goneCourtier
  ) where

import Text.Numeral.Roman (toRoman)

import Annales.Empire (
  TextGenCh
  ,Empire
  ,Person(..)
  ,court
  ,heirs
  ,emperor
  ,consort
  ,vocabGet
  ,personGet
  ,pName
  ,generate
  ,dumbjoin
  ,cap
  ,inc
  ,randn
  ,randRemove
  ,elemPerson
  ,removePerson
  ,chooseW
  )

import Annales.Emperor (
  newPerson
  )

import Annales.Descriptions (
  descCourtier
  ,descCourtDouble
  ,descCourtierGo
  )

import TextGen (
  TextGen
  ,word
  ,choose
  ,remove
  ,list
  )

import Annales.Omens ( omen )
  

import Data.Maybe (catMaybes)



newCourtier :: Empire -> IO ( Empire, TextGenCh )
newCourtier e = do
  p <- newPerson e
  dup <- elemPerson p $ court e
  case dup of
    False -> do
      e' <- return $ e { court = p:(court e) }
      return ( e', descCourtier e p )
    True -> do
      return ( e, descCourtDouble e p )



goneCourtier :: Empire -> IO ( Empire, TextGenCh )
goneCourtier e = do
  ( mgone, court' ) <- randRemove $ court e
  case mgone of
    []     -> omen e
    gone:c -> do
      others <- removePerson gone $ allCourt e
      e' <- return $ e { court = court' }
      return ( e', descCourtierGo e gone others ) 






allCourt :: Empire -> [ Person ]
allCourt e = ( royals ++ (heirs e) ++ (court e) )
  where royals = catMaybes [ emperor e, consort e ]


