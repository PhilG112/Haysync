{-# LANGUAGE OverloadedStrings #-}

module Main where
import Control.Concurrent.Async (Async, withAsync, wait)
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status
import System.Environment (getArgs)
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.ByteString as B
import ConfigUtil ( getConfig, Config(..), ApiEndpointConfig(..), AuthConfig(..) )
import Network.HTTP.Types
import Data.Word
import Data.Text.Encoding
import qualified Data.Text as T

main :: IO ()
main = do
    cfg <- getConfig "appsettings.dev.ini"
    let e = cfgApiEndpoints cfg
    let endpoint = api e

    let a = cfgAuth cfg
    let t = token a
    args <- getArgs
    withAsync (someRequest (endpoint ++ "/orders/" ++ head args) t) $ \a1 -> do
        w1 <- wait a1
        print w1

someRequest :: String -> String -> IO String
someRequest url authToken = do
    manager <- newManager tlsManagerSettings

    initReq <- parseRequest url
    let req = initReq
            { method = "GET"
            , secure = True
            , requestHeaders = [("Authorization", encodeUtf8 $ T.pack authToken)]
            }
    response <- httpLbs req manager 

    putStrLn $ "Status " ++ show (statusCode $ responseStatus response)
    pure $ BS.unpack $ responseBody response
