## https://github.com/jennybc/lotr-tidy#readme

library(tidyverse)
library(gapminder)

# read data
male <- read_csv(file.path("lotr-tidy-data", "Male.csv"))
female <- read_csv(file.path("lotr-tidy-data", "Female.csv"))

# bind rows
gender_untidy <- bind_rows(male, female)
str(gender_untidy)
gender_untidy

# gather up the word counts into a single variable and create a new variable, 
# Gender, to track whether each count refers to females or males.
gender_tidy <-
  gather(gender_untidy, key = 'Race', value = 'Words', Elf, Hobbit, Man)
gender_tidy

# Write the tidy data to a delimited file
write_csv(gender_tidy, path = file.path("lotr-tidy-data", "lotr_tidy_gender_race.csv"))

# the total number of words spoken by each race across the entire trilogy. 
gender_tidy %>% 
  count(Race, wt=Words)

# the total number of words spoken in each film.
gender_tidy %>% 
  count(Film, wt=Words)
