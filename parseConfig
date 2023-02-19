-- Parse configuration values from string
parseConfig :: String -> [(String, String)]
parseConfig = map parseLine . lines
  where
    parseLine line =
      let (key, val) = break (== '=') line
      in (trim key, trim $ tail val)

    trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse
    
    
   {-
   This implementation uses map to apply the parseLine function to each line of the input string. 
   The parseLine function splits the line into a key-value pair using break and trims the key and value using the trim function.

  Note that this implementation assumes that the configuration values are one per line, in the format key=value. 
  You may need to modify it to handle other formats depending on the format of your configuration file.
  -}
