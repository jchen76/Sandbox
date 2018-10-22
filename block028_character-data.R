# http://stat545.com/block028_character-data.html

# stringr.
# tidyr: separate(),  unite(), extract().
# base: nchar(), strsplit(), substr(), paste(), paste0().
# glue: if stringr::str_interp() doesn’t get your job done, check out glue.

library(tidyverse)
library(stringr)

# Regex-free string manipulation with stringr and tidyr
# Detect or filter on a target string
str_detect(fruit, pattern = "fruit")
(my_fruit <- str_subset(fruit, pattern = "fruit"))

# String splitting by delimiter
str_split(my_fruit, pattern = " ")
str_split_fixed(my_fruit, pattern = " ", n = 2)
my_fruit_df <- tibble(my_fruit)
my_fruit_df %>% 
  separate(my_fruit, into = c("pre", "post"), sep = " ")

# Substring extraction (and replacement) by position
length(my_fruit)
str_length(my_fruit)
head(fruit) %>% 
  str_sub(1, 3)
tibble(fruit) %>% 
  head() %>% 
  mutate(snip = str_sub(fruit, 1:6, 3:8))
(x <- head(fruit, 3))
str_sub(x, 1, 3) <- "AAA"
x

# Collapse a vector
head(fruit) %>% 
  str_c(collapse = ", ")

# Create a character vector by catenating multiple vectors
str_c(fruit[1:4], fruit[5:8], sep = " & ")
str_c(fruit[1:4], fruit[5:8], sep = " & ", collapse = ", ")
fruit_df <- tibble(
  fruit1 = fruit[1:4],
  fruit2 = fruit[5:8]
)
# data frame
fruit_df %>% 
  unite("flavor_combo", fruit1, fruit2, sep = " & ")

# Substring replacement
str_replace(my_fruit, pattern = "fruit", replacement = "THINGY")
melons <- str_subset(fruit, pattern = "melon")
melons[2] <- NA
melons
str_replace_na(melons, "UNKNOWN MELON")
# data frame
tibble(melons) %>% 
  replace_na(replace = list(melons = "UNKNOWN MELON"))

# regular expression
# Characters with special meaning
library(gapminder)
countries <- levels(gapminder$country)
str_subset(countries, pattern = "i.a")
str_subset(countries, pattern = "i.a$")
str_subset(my_fruit, pattern = "d")
str_subset(my_fruit, pattern = "^d")
str_subset(fruit, pattern = "melon")
str_subset(fruit, pattern = "\\bmelon")
str_subset(fruit, pattern = "\\Bmelon")

# Character classes
str_subset(countries, pattern = "[nls]ia$")
str_subset(countries, pattern = "[^nls]ia$")
str_split_fixed(my_fruit, pattern = "\\s", n = 2)
str_split_fixed(my_fruit, pattern = "[[:space:]]", n = 2)
str_subset(countries, "[[:punct:]]")

# Quantifiers
(matches <- str_subset(fruit, pattern = "l.*e"))
list(match = intersect(matches, str_subset(fruit, pattern = "l.+e")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "l.+e")))
list(match = intersect(matches, str_subset(fruit, pattern = "l.?e")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "l.?e")))
list(match = intersect(matches, str_subset(fruit, pattern = "le")),
     no_match = setdiff(matches, str_subset(fruit, pattern = "le")))

# Escaping
# Escapes in plain old strings
cat("Do you use \"airquotes\" much?")
cat("before the newline\nafter the newline")
cat("before the tab\tafter the tab")
# Escapes in regular expressions
str_subset(countries, pattern = "[[:punct:]]")
str_subset(countries, pattern = "\\.")
(x <- c("whatever", "X is distributed U[0,1]"))
str_subset(x, pattern = "\\[")

# Groups and backreferences
# You can use parentheses inside regexes to define groups and you can refer to those groups later with backreferences.