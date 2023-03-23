{-# LANGUAGE OverloadedStrings #-}

module ConfigUtil (getConfig, Config(..), ApiEndpointConfig(..), AuthConfig(..)) where

import Data.Ini.Config (IniParser, section, fieldOf, string, parseIniFile)
import qualified Data.Text as T
import System.IO

data Config = Config
    { cfgApiEndpoints :: ApiEndpointConfig
    , cfgAuth :: AuthConfig
    }

data ApiEndpointConfig = ApiEndpointConfig
    { api :: String
    }

data AuthConfig = AuthConfig
    { token :: String
    }

configParser :: IniParser Config
configParser = do
    endpoints <- section "APIENDPOINTS" $ do
        api <- fieldOf "api" string
        return ApiEndpointConfig { api = api }
    authCfg <- section "AUTH" $ do
        token <- fieldOf "token" string
        return AuthConfig { token = token }
    return Config {cfgApiEndpoints = endpoints, cfgAuth = authCfg}

type FileName = String
getConfig :: FileName -> IO Config
getConfig filename = do
    handle <- openFile filename ReadMode
    contents <- hGetContents handle
    case parseIniFile (T.pack contents) configParser of
        Left s -> error s
        Right a -> return a