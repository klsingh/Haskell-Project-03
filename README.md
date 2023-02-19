# Haskell_Project3
## Program 1: Reading and Processing a Configuration File with Monads and Custom Constructs

### ConfigError

The ConfigError type is a custom error monad that is used to represent errors that may occur while processing the configuration. It has one constructor InvalidConfig that takes a String message describing the error.

```
data ConfigError = InvalidConfig String
```
### ConfigM

The ConfigM type is a type alias for the Either monad specialized to ConfigError and another type a. This allows us to handle errors that may occur while processing the configuration.

```
type ConfigM a = Either ConfigError a
```

### Config

The Config type is a custom data type that represents the configuration values. It has three fields: serverName, serverPort, and maxConnections, all of which are of type String.

```

data Config = Config {
    serverName :: String,
    serverPort :: Int,
    maxConnections :: Int
}

```
### readConfig

The readConfig function takes a file path and returns a ConfigM Config value, representing a Config value that is either successfully parsed and validated, or an error that occurred while parsing or validating the configuration.

The function uses the Reader monad to read the file contents, and then calls the parseConfig function to parse the configuration values from the file contents. It then calls the validateConfig function to validate the configuration values and convert them to the appropriate types.

```

readConfig :: FilePath -> ConfigM Config
readConfig path = do
    contents <- runReaderT (readFile path) ()
    let values = parseConfig contents
    validateConfig values
```

### parseConfig

The parseConfig function takes a string representing the contents of a configuration file, and returns a list of key-value pairs representing the configuration values.

The function uses the lines function to split the input string into lines, and then uses map to apply the parseLine function to each line. The parseLine function splits the line into a key-value pair using break, and trims the key and value using the trim function.

```
parseConfig :: String -> [(String, String)]
parseConfig = map parseLine . lines
  where
    parseLine line =
      let (key, val) = break (== '=') line
      in (trim key, trim $ tail val)

    trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse
```


### validateConfig

The validateConfig function takes a list of key-value pairs representing the configuration values, and returns a ConfigM Config value representing a validated Config value, or an error that occurred while validating the configuration.

The function uses the lookupValue helper function to look up the values for serverName, serverPort, and maxConnections. It then uses the reads function to convert the string values for serverPort and maxConnections to the appropriate types (Int).

If all values are present and correctly formatted, the function returns a Config value with the validated values. Otherwise, it returns an error.

```
validateConfig :: [(String, String)] -> ConfigM Config
validateConfig values = do
    serverName <- lookupValue "server_name" values
    serverPort <- lookupValue "server_port" values
    maxConnections <- lookupValue "max_connections" values
```
   
