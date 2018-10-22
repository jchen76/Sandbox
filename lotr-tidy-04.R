## https://github.com/jennybc/lotr-tidy/blob/master/04-tidy-bonus-content.md

library(tidyverse)
library(gapminder)

# read data
fship <- read.csv(file.path("lotr-tidy-data", "The_Fellowship_Of_The_Ring.csv"))
ttow <- read.csv(file.path("lotr-tidy-data", "The_Two_Towers.csv"))
rking <- read.csv(file.path("lotr-tidy-data", "The_Return_Of_The_King.csv"))  
# it would be a problem, if we combine variables in factors.
# rbind automatically converts them into char.
lotr_untidy <- rbind(fship, ttow, rking)
lotr_untidy

# another way to read files into a list
lotr_files <- file.path("lotr-tidy-data", c("The_Fellowship_Of_The_Ring.csv",
                                  "The_Two_Towers.csv",
                                  "The_Return_Of_The_King.csv"))
lotr_list <- lapply(lotr_files, read.csv)
str(lotr_list)
lotr_untidy_3 <- rbind(lotr_list[[1]], lotr_list[[2]], lotr_list[[3]])
str(lotr_untidy_3)

# use do.call
lotr_untidy_4 <- do.call(rbind, lotr_list)
str(lotr_untidy_4)

# much efficent solution
lotr_untidy5 <- bind_rows(fship, ttow, rking)
str(lotr_untidy5)
lotr_untidy5

## about gathering variables

# base R solution
lotr_tidy <-
  with(lotr_untidy,
       data.frame(Film = Film,
                  Race = Race,
                  Words = c(Female, Male),
                  Gender =rep(c("Female", "Male"), each = nrow(lotr_untidy))))
lotr_tidy

# using stack
lotr_tidy_2 <-
  with(lotr_untidy,
       data.frame(Film = Film,
                  Race = Race,
                  stack(lotr_untidy, c(Female, Male))))
names(lotr_tidy_2) <- c('Film', 'Race', 'Words', 'Gender')
lotr_tidy_2

# melt
library(reshape2)
lotr_tidy_4 <-
  melt(lotr_untidy, measure.vars = c("Female", "Male"), value.name = 'Words')
lotr_tidy_4

# better solution
library(tidyr)
lotr_tidy_3 <-
  gather(lotr_untidy, key = 'Gender', value = 'Words', Female, Male)
lotr_tidy_3