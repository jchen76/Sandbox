# http://stat545.com/block028_character-data.html

library(gapminder)
library(tidyverse)
library(stringr)

# tidyr: separate(),  unite(), extract()
# base: nchar(), strsplit(), substr(), paste(), paste0()
# fruit, words, and sentences are character vectors that ship with stringr for practicing.

# Detect or filter on a target string
str_detect(fruit, "fruit")
# get the actual fruits that match? 
(my_fruit <- str_subset(fruit, "fruit"))
# String splitting by delimiter
str_split(my_fruit, " ")
# to get a char matrix instead of a list
str_split_fixed(my_fruit, " ", n = 2)
# for data frame
my_fruit_df <- tibble(my_fruit)
my_fruit_df %>% 
  separate(my_fruit, into = c("pre", "post"), sep = " ")

# length
length(my_fruit)
str_length(my_fruit)
# sub string
head(fruit) %>% 
  str_sub(1, 3)
# The start and end arguments are vectorised.
tibble(fruit) %>% 
  head() %>% 
  mutate(snip = str_sub(fruit, 1:6, 3:8))
# str_sub() also works for assignment, i.e. on the left hand side of <-.
x <- head(fruit, 3)
str_sub(x, 1, 3) <- "AAA"
x

# Collapse a vector
head(fruit) %>% 
  str_c(collapse = ", ")
# Create a character vector by catenating multiple vectors
str_c(fruit[1:4], fruit[5:8], sep = " & ")
# combine with collapsing
str_c(fruit[1:4], fruit[5:8], sep = " & ", collapse = ", ")
# If the to-be-combined vectors are variables in a data frame, you can use tidyr::unite()
fruit_df <- tibble(fruit1 = fruit[1:4], fruit2 = fruit[5:8])
fruit_df %>% 
  unite("flavor_combo", fruit1, fruit2, sep = " & ")

# replacement
str_replace(my_fruit, "fruit", "THINGY")
# replace NA
melons <- str_subset(fruit, "melon")
melons[2] <- NA
melons
str_replace_na(melons, "UNKNOWN MELON")
# for data frame
tibble(melons) %>% 
  replace_na(replace = list(melons = "UNKNOWN MELON"))

# Regex
countries <- levels(gapminder$country)
str_subset(countries, "i.a")
str_subset(countries, "i.a$")
str_subset(my_fruit, "d")
str_subset(my_fruit, "^d")
str_subset(fruit, "melon")
str_subset(fruit, "\\bmelon")
str_subset(fruit, "\\Bmelon")

# Character classes
str_subset(countries, "[nls]ia$")
str_subset(countries, "[^nls]ia$")

# space and punchuation
str_split_fixed(my_fruit, "\\s", 2)
str_split_fixed(my_fruit, "[[:space:]]", 2)
str_subset(countries, "[[:punct:]]")

# Quantifiers
(matches <- str_subset(fruit, "l.*e"))
list(match = intersect(matches, str_subset(fruit, "l.+e")),
     no_match = setdiff(matches, str_subset(fruit, "l.+e")))
list(match = intersect(matches, str_subset(fruit, "l.?e")),
     no_match = setdiff(matches, str_subset(fruit, "l.?e")))
list(match = intersect(matches, str_subset(fruit, "le")),
     no_match = setdiff(matches, str_subset(fruit, "le")))

# escaping
cat("Do you use \"airquotes\" much?")
cat("before the newline\nafter the newline")
cat("before the tab\tafter the tab")
str_subset(countries, "[[:punct:]]")
str_subset(countries, "\\.")
(x <- c("whatever", "X is distributed U[0,1]"))
str_subset(x, "\\[")