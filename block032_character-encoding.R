# http://stat545.com/block032_character-encoding.html

library(gapminder)
library(tidyverse)
library(stringr)

# in hexdecimal
charToRaw("hello!")
# in decimal
as.integer(charToRaw("hello!"))

# it takes more than one byte to represent "ṏ".
charToRaw("hellṏ!")
as.integer(charToRaw("hellṏ!"))

# ISO-8859-1 (also known as “Latin1”)
string_latin <- iconv("hellÔ!", from = "UTF-8", to = "Latin1")
string_latin
charToRaw(string_latin)
as.integer(charToRaw(string_latin))
iconv(string_latin, from = "ISO-8859-5", to = "UTF-8")

# not all strings can be represented in all encodings
(string <- "hi∑")
Encoding(string)
as.integer(charToRaw(string))
(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252"))
# you can specify a substitution for non-convertible bytes.
(string_windows <- iconv(string, from = "UTF-8", to = "Windows-1252", sub = "?"))

# A three-step process for fixing encoding bugs
# 1. Discover which encoding your string is actually in.
# the most common encodings are UTF-8, ISO-8859-1 (or Latin1), and Windows-1252
# Shhh. Secret: this is encoded as Windows-1252
string <- "hi\x99!"
string
Encoding(string)
stringi::stri_enc_detect(string)
# 2. Decide which encoding you want the string to be
# That’s easy. UTF-8. Done.
string_windows <- "hi\x99!"
# 3. Re-encode your string
string_utf8 <- iconv(string_windows, from = "Windows-1252", to = "UTF-8")
Encoding(string_utf8)
string_utf8

# How to Get From Theyâ€™re to They’re
string_curly <- "they’re"
charToRaw(string_curly)
as.integer(charToRaw(string_curly))
length(as.integer(charToRaw(string_curly)))
nchar(string_curly)
# notes claim 3 bytes, but show one
charToRaw("’")
as.integer(charToRaw("’"))
length(as.integer(charToRaw("’")))

# reset
string_curly <- "Theyâ€™re"
stringi::stri_enc_detect(string_curly)
# wrong interpretation
(string_mis_encoded <- iconv(string_curly, to = "UTF-8", from = "windows-1252"))
# correct interpretation
(string_mis_encoded <- iconv(string_curly, from = "UTF-8", to = "windows-1252"))

# Encoding repair
# You have a UTF-8 encoded string. Convert it back to Windows-1252, to get the original bytes.
# Then re-encode that as UTF-8.
(string_mis_encoded <- iconv(string_curly, to = "UTF-8", from = "windows-1252"))
backwards_one <- iconv(string_mis_encoded, from = "UTF-8", to = "Windows-1252")
backwards_one
Encoding(backwards_one)
as.integer(charToRaw(backwards_one))
as.integer(charToRaw(string_curly))
