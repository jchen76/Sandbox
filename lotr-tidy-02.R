## https://github.com/jennybc/lotr-tidy#readme

library(tidyverse)
library(gapminder)

# read data
fship <- read_csv(file.path("lotr-tidy-data", "The_Fellowship_Of_The_Ring.csv"))
ttow <- read_csv(file.path("lotr-tidy-data", "The_Two_Towers.csv"))
rking <- read_csv(file.path("lotr-tidy-data", "The_Return_Of_The_King.csv")) 

# bind rows
lotr_untidy <- bind_rows(fship, ttow, rking)
str(lotr_untidy)
lotr_untidy

# gather up the word counts into a single variable and create a new variable, 
# Gender, to track whether each count refers to females or males.
lotr_tidy <-
  gather(lotr_untidy, key = 'Gender', value = 'Words', Female, Male)
lotr_tidy

# Write the tidy data to a delimited file
write_csv(lotr_tidy, path = file.path("lotr-tidy-data", "lotr_tidy.csv"))
