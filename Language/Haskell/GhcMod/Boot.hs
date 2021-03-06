module Language.Haskell.GhcMod.Boot where

import Control.Applicative ((<$>))
import CoreMonad (liftIO, liftIO)
import GHC (Ghc)
import Language.Haskell.GhcMod.Browse
import Language.Haskell.GhcMod.Flag
import Language.Haskell.GhcMod.GHCApi
import Language.Haskell.GhcMod.Lang
import Language.Haskell.GhcMod.List
import Language.Haskell.GhcMod.Types

-- | Printing necessary information for front-end booting.
bootInfo :: Options -> Cradle -> IO String
bootInfo opt cradle = withGHC' $ do
    initializeFlagsWithCradle opt cradle
    boot opt

-- | Printing necessary information for front-end booting.
boot :: Options -> Ghc String
boot opt = do
    mods  <- modules opt
    langs <- liftIO $ listLanguages opt
    flags <- liftIO $ listFlags opt
    pre   <- concat <$> mapM (browse opt) preBrowsedModules
    return $ mods ++ langs ++ flags ++ pre

preBrowsedModules :: [String]
preBrowsedModules = [
    "Prelude"
  , "Control.Applicative"
  , "Control.Exception"
  , "Control.Monad"
  , "Data.Char"
  , "Data.List"
  , "Data.Maybe"
  , "System.IO"
  ]
