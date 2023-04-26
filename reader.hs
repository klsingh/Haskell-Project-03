import Control.Monad.Reader

-- Custom error monad
data ConfigError = InvalidConfig String

instance Show ConfigError where
    show (InvalidConfig msg) = "Invalid configuration: " ++ msg

type ConfigM a = Either ConfigError a

-- Custom configuration type
data Config = Config {
    serverName :: String,
    serverPort :: Int,
    maxConnections :: Int
}

-- Read configuration file and return a Config value
readConfig :: FilePath -> ConfigM Config
readConfig path = do
    -- Read configuration file using Reader monad
    contents <- runReaderT (readFile path) ()

    -- Parse configuration values from file contents
    let values = parseConfig contents

    -- Validate configuration values
    validateConfig values

-- Parse configuration values from string
parseConfig :: String -> [(String, String)]
parseConfig = undefined -- Implementation omitted for brevity

-- Validate configuration values and return a Config value
validateConfig :: [(String, String)] -> ConfigM Config
validateConfig values = do
    -- Check for required values
    serverName <- lookupValue "server_name" values
    serverPort <- lookupValue "server_port" values
    maxConnections <- lookupValue "max_connections" values

    -- Convert values to appropriate types
    port <- case reads serverPort of
        [(p, "")] -> return p
        _ -> throwError (InvalidConfig "Invalid server_port value")

    conn <- case reads maxConnections of
        [(c, "")] -> return c
        _ -> throwError (InvalidConfig "Invalid max_connections value")

    -- Create Config value
    return Config { serverName = serverName, serverPort = port, maxConnections = conn }

-- Look up value by key in list of key-value pairs
lookupValue :: String -> [(String, String)] -> ConfigM String
lookupValue key values = case lookup key values of
    Just val -> return val
    Nothing -> throwError (InvalidConfig $ "Missing value for " ++ key)
    
{-
 In this program, the readConfig function uses the Reader monad to read in a configuration file, and the validateConfig function uses a custom error monad ConfigM to handle errors that may occur while processing the configuration. 
 The lookupValue function is a helper function that returns the value associated with a key in a list of key-value pairs.

Note that this program is incomplete, as the parseConfig function is left undefined for brevity. 
You would need to implement parseConfig to actually parse the configuration values from the file contents.
-}
