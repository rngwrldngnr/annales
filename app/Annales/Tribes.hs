module Annales.Tribes ( newTribe, goneTribe ) where

import Annales.Empire (
  TextGenCh
  ,Empire
  ,tribes
  ,vocabGet
  ,generate
  ,wordjoin
  ,chooseW
  )

import TextGen (
  TextGen
  ,word
  ,choose
  ,remove
  ,list
  )


import Annales.Omens ( omen )
 

newTribe :: Empire -> IO ( Empire, TextGenCh )
newTribe e = do
  tribe  <- generate $ vocabGet e "tribes"
  tribeg <- return $ wordjoin tribe
  e'   <- return $ e { tribes = tribeg:(tribes e) }
  return ( e', tribeDescribe e tribeg )


-- tribeDescribe :: Empire -> TextGenCh -> TextGenCh
-- tribeDescribe e tribe = list [ word "The", tribe, word ",", nation, description, arose ]
--   where nation = list [ word "a", mighty, people ]
--         mighty = vocabGet e "epithets"
--         people = vocabGet e "nations"
--         description = list [ word ",", proneto, vocabGet e "immorality", word "," ]
--         proneto = chooseW [ "prone to", "given to", "notorious for", "infamous for", "great in" ]
--         arose = list [ word "arose in", vocabGet e "places" ]



tribeDescribe :: Empire -> TextGenCh -> TextGenCh
tribeDescribe e t = let v = vocabGet e
                        w = word
                        c = w ","
                        nation = list [ v "epithets", v "nations" ]
                        givento = chooseW [ "prone to", "given to", "notorious for", "infamous for", "great in", "big with" ]
                        wickedness = v "immorality"
                        arose = list [ w "arose in", v "places" ]
  in list [ w "The", t, c, w "a", nation, c, givento, wickedness, c, arose ]


goneTribe :: Empire -> IO ( Empire, TextGenCh )
goneTribe e = do
  ( maybetribe, tribes' ) <- generate $ remove $ tribes e
  case maybetribe of
    Nothing -> omen e
    Just tribe -> do
      e' <- return $ e { tribes = tribes' }
      return ( e', tribeGo e tribe ) 

tribeGo :: Empire -> [[Char]] -> TextGenCh
tribeGo e tc = list [ word "The", wordjoin tc, went ]
  where went = choose [ dwindled, conquered, migrated, fled ]
        dwindled = chooseW [ "dwindled", "dissolved", "failed" ]
        conquered = list [ word "were conquered by the", vocabGet e "tribes" ]
        migrated = list [ word "migrated to the", chooseW [ "north", "west", "east", "south" ] ]
        fled = list [ cursed, vocabGet e "phenomena" ]
        cursed = chooseW [ "were cursed with", "fled the", "fled in the face of" ]
