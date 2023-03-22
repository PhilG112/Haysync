{-# LANGUAGE OverloadedStrings #-}

module Main where
import Control.Concurrent.Async (Async, withAsync, wait)
import Network.HTTP.Client
import Network.HTTP.Types.Status
import System.Environment (getArgs)
import qualified Data.ByteString.Lazy.Char8 as BS

main :: IO ()
main = do
    ar <- getArgs
    withAsync (someRequest (head ar)) $ \a1 -> do
        w1 <- wait a1
        print w1

someRequest :: String -> IO String
someRequest url = do
    manager <- newManager defaultManagerSettings

    initReq <- parseRequest url
    let req = initReq
            { method = "GET"
            , secure = True    
            }
    response <- httpLbs req manager 

    putStrLn $ "Status " ++ (show $ statusCode $ responseStatus response)
    return $ BS.unpack $ responseBody response 